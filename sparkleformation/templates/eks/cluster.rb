SparkleFormation.new(:eks_cluster).load(:template_base).overrides do
	description "EKS Cluster"

  parameters.cluster_name do
    description 'The name of the eks cluster'
    registry!(:string_aws_parameter_type)
  end

  # See https://docs.aws.amazon.com/eks/latest/userguide/platform-versions.html
  parameters.cluster_version do
    description 'The version of the EKS Cluster'
    registry!(:string_aws_parameter_type)
    default '1.12'
  end

  parameters.subnets do
    description 'Specify at least 2 subnets for your Amazon EKS worker nodes'
    registry!(:comma_delimited_list_aws_parameter_type)
  end

  parameters.vpc_id do
    description 'The ID of the VPC'
    registry!(:vpc_id_aws_parameter_type)
  end

  parameters.sns_email do
    description 'Email to send notifications'
    registry!(:string_aws_parameter_type)
    default 'dev-ops@electricimp.com'
  end
  
  #---------------------------------------------------------
  # IAM Service Role
  #---------------------------------------------------------  

  resources.eks_automation_lambda_function_iam_role do 
    type "AWS::IAM::Role"
    properties do
      policies _array(
        -> {
          policy_name 'elastic_kubernetes_service'
          policy_document.version '2012-10-17'
          policy_document.statement _array(
            -> {
              effect 'Allow'
              action _array(
                'eks:Describe*',
                'eks:List*',
                'eks:Update*',
              )
              resource '*'
            }
          )
        }
      )
      assume_role_policy_document do
        version '2012-10-17'
        statement _array(
          -> {
            effect 'Allow'
            principal.service 'lambda.amazonaws.com'
            action 'sts:AssumeRole'
          }
        )
      end
      managed_policy_arns _array(
        "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
      )
    end                
  end

  resources.cluster_administration_iam_role do 
    type "AWS::IAM::Role"
    properties do
      assume_role_policy_document do
        version '2012-10-17'
        statement _array(
          -> {
            effect 'Allow'
            principal.service 'eks.amazonaws.com'
            action 'sts:AssumeRole'
          }
        )
      end
      managed_policy_arns _array(
        "arn:aws:iam::aws:policy/AmazonEKSServicePolicy",
        "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
      )
    end               
  end

  resources.cluster_iam_role do 
    type "AWS::IAM::Role"
    properties do
      assume_role_policy_document do
        version '2012-10-17'
        statement _array(
          -> {
            effect 'Allow'
            principal.service 'eks.amazonaws.com'
            action 'sts:AssumeRole'
          }
        )
      end
      managed_policy_arns _array(
        "arn:aws:iam::aws:policy/AmazonEKSServicePolicy",
        "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
      )
    end               
  end
  
  resources.worker_node_iam_role do 
    type "AWS::IAM::Role"
    properties do
      policies _array(
        -> {
          policy_name 'autoscaling'
          policy_document.version '2012-10-17'
          policy_document.statement _array(
            -> {
              effect 'Allow'
              action _array(
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeTags",
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup"
              )
              resource '*'
            }
          )
        }
      )  
      assume_role_policy_document do
        version '2012-10-17'
        statement _array(
          -> {
            effect 'Allow'
            principal.service 'ec2.amazonaws.com'
            action 'sts:AssumeRole'
          }
        )
      end
      path "/"
      managed_policy_arns _array(
        "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
        "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
        "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
      )
    end               
  end

  resources.worker_node_instance_profile do 
    type "AWS::IAM::InstanceProfile"
    properties do
      path "/"
      roles _array( 
        ref!(:worker_node_iam_role) 
      )
    end
    depends_on depends_on!(
      :worker_node_iam_role
    )               
  end 

  #---------------------------------------------------------
  # Security Groups  
  #---------------------------------------------------------

  resources.control_plane_security_group do
    type 'AWS::EC2::SecurityGroup'
    properties do
      vpc_id ref!(:vpc_id)
      group_description join!("EKS cluster ", ref!(:cluster_name), " control plane")
      tags _array(
        { Key: 'Name', Value: join!("EKS cluster ", ref!(:cluster_name), " control plane")  },
        { Key: join!("kubernetes.io/cluster/", ref!(:cluster_name)), Value: 'owned'}
      )
    end
  end

  resources.worker_node_security_group do
    type 'AWS::EC2::SecurityGroup'
    properties do
      vpc_id ref!(:vpc_id)
      group_description join!("EKS cluster ", ref!(:cluster_name), " worker nodes")
      tags _array(
        { Key: 'Name', Value: join!("EKS cluster ", ref!(:cluster_name), " worker nodes")  },
        { Key: join!("kubernetes.io/cluster/", ref!(:cluster_name)), Value: 'owned'}
      )
    end
  end

  #---------------------------------------------------------
  # Control Plane Security Group Rules  
  #---------------------------------------------------------

  resources.control_plane_security_group do
    type 'AWS::EC2::SecurityGroup'
    properties do
      vpc_id ref!(:vpc_id)
      group_description join!("EKS cluster ", ref!(:cluster_name), " control plane")
      tags _array(
        { Key: 'Name', Value: join!("EKS cluster ", ref!(:cluster_name), " control plane")  },
        { Key: join!("kubernetes.io/cluster/", ref!(:cluster_name)), Value: 'owned'}
      )
    end
  end

  resources.control_pane_inbound_traffic_from_worker_nodes do
    type 'AWS::EC2::SecurityGroupIngress'
    properties do
      from_port 443
      to_port 443
      ip_protocol registry!(:tcp_ip_protocol)
      source_security_group_id ref!(:worker_node_security_group)
      group_id ref!(:control_plane_security_group)
    end
    depends_on depends_on!(
      :worker_node_security_group,
      :control_plane_security_group
    )
  end

  resources.control_pane_outbound_traffic_to_worker_nodes do
    type 'AWS::EC2::SecurityGroupEgress'
    properties do
      from_port 1025
      to_port 65535
      ip_protocol registry!(:tcp_ip_protocol)
      destination_security_group_id ref!(:worker_node_security_group)
      group_id ref!(:control_plane_security_group)
    end
    depends_on depends_on!(
      :worker_node_security_group,
      :control_plane_security_group
    )
  end
  
  #---------------------------------------------------------
  # Worker Nodes Security Group Rules  
  #---------------------------------------------------------

  resources.worker_node_to_node_communication do
    type 'AWS::EC2::SecurityGroupIngress'
    properties do
      from_port -1
      to_port -1
      ip_protocol -1
      source_security_group_id ref!(:worker_node_security_group)
      group_id ref!(:worker_node_security_group)
    end
    depends_on depends_on!(:worker_node_security_group)
  end

  resources.worker_nodes_inbound_control_plane_tcp_port_443 do
    type 'AWS::EC2::SecurityGroupIngress'
    properties do
      from_port 443
      to_port 443
      ip_protocol registry!(:tcp_ip_protocol)
      source_security_group_id ref!(:control_plane_security_group)
      group_id ref!(:worker_node_security_group)
    end
    depends_on depends_on!(
      :worker_node_security_group,
      :control_plane_security_group
    )
  end

  resources.worker_nodes_inbound_control_plane_tcp_port_port_1025_to_65535 do
    type 'AWS::EC2::SecurityGroupIngress'
    properties do
      from_port 1025
      to_port 65535
      ip_protocol registry!(:tcp_ip_protocol)
      source_security_group_id ref!(:control_plane_security_group)
      group_id ref!(:worker_node_security_group)
    end
    depends_on depends_on!(
      :worker_node_security_group,
      :control_plane_security_group
    )
  end

  resources.worker_nodes_outbound_to_internet do
    type 'AWS::EC2::SecurityGroupEgress'
    properties do
      from_port -1
      to_port -1
      ip_protocol -1
      cidr_ip registry!(:internet_wide_communication_cidr)
      group_id ref!(:worker_node_security_group)
    end
    depends_on depends_on!(:worker_node_security_group)
  end

  #---------------------------------------------------------
  # EKS Cluster  
  #---------------------------------------------------------

  resources.eks_cluster do 
    type "AWS::EKS::Cluster"
    properties do
      name ref!(:cluster_name) 
      role_arn attr!(:cluster_iam_role, :arn) 
      version ref!(:cluster_version)  
      resources_vpc_config do 
        security_group_ids  _array(
          ref!(:control_plane_security_group)
        )
        subnet_ids ref!(:subnets)  
      end
    end
    depends_on depends_on!(
      :cluster_iam_role,
      :worker_node_security_group,
      :control_plane_security_group
    )             
  end

  #---------------------------------------------------------
  # SNS Topic 
  #---------------------------------------------------------    
    
  resources.sns_topic do
    type 'AWS::SNS::Topic'
    properties do
      display_name join!("EKS cluster ", ref!(:cluster_name), " notifications")
      subscription [{Endpoint: ref!(:sns_email), Protocol: 'email'}]
    end
  end

  #---------------------------------------------------------
  # Outputs 
  #---------------------------------------------------------    
    
  outputs.cluster_name do
    description 'The name of the cluster'
    value ref!(:cluster_name)
  end

  outputs.cluster_version do
    description 'The version of EKS running on the cluster'
    value ref!(:cluster_version)
  end

  outputs.cluster_arn do
    description 'The ARN of the cluster'
    value attr!(:eks_cluster, :arn) 
  end

  outputs.cluster_certificate_authority_data do
    description 'The certificate-authority-data for the cluster'
    value attr!(:eks_cluster, :certificate_authority_data) 
  end

  outputs.cluster_endpoint do
    description 'The endpoint for your Kubernetes API server'
    value attr!(:eks_cluster, :endpoint) 
  end

  outputs.cluster_iam_role_arn do
    description 'The IAM service role ARN used by the cluster'
    value attr!(:cluster_iam_role, :arn)
  end

  outputs.worker_node_iam_role_arn do
    description 'The IAM service role ARN used by the worker nodes'
    value attr!(:worker_node_iam_role, :arn)
  end

  outputs.worker_node_instance_profile_id do
    description 'The IAM instance profile ID role used by the worker nodes'
    value ref!(:worker_node_instance_profile)
  end

  outputs.control_plane_security_group_id do
    description 'The control plane security group ID'
    value ref!(:control_plane_security_group)
  end

  outputs.worker_node_security_group_id do
    description 'The worker node security group ID'
    value ref!(:worker_node_security_group)
  end

  outputs.sns_topic_id do
    description 'The SNS topic ID'
    value ref!(:sns_topic)
  end

end
