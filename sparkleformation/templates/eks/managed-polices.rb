SparkleFormation.new(:eks_managed_polices, compile_time_parameters: {}).load(:base).overrides do
  description "EC2 - EKS Managed Polices"
  
  resources.cluster_autoscaler do 
    type "AWS::IAM::ManagedPolicy"
    properties do
      path "/kubernetes/"
      managed_policy_name "ClusterAutoScaler"
      description "Policy required for the cluster-autoscaler kubernetes component"
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
    end               
  end

  # See https://github.com/kubernetes-incubator/external-dns/blob/master/docs/tutorials/aws.md
  resources.external_dns_controller do 
    type "AWS::IAM::ManagedPolicy"
    properties do
      path "/kubernetes/"
      managed_policy_name "ExternalDnsController"
      description "Policy required for the external DNS kubernetes controller"
      policy_document.version '2012-10-17'
      policy_document.statement _array(
        -> {
          effect 'Allow'
          action _array(
            "route53:ChangeResourceRecordSets"
          )
          resource 'arn:aws:route53:::hostedzone/*'
        },
        -> {
          effect 'Allow'
          action _array(
            "route53:ListHostedZones",
            "route53:ListResourceRecordSets"
          )
          resource '*'
        }
      )
    end               
  end

  # See https://github.com/kubernetes-incubator/external-dns/blob/master/docs/tutorials/aws-sd.md
  # Important: To use the service discovery API, a user executing the ExternalDNS must have the permissions in the AmazonRoute53AutoNamingFullAccess managed policy.
  resources.external_service_discovery_dns_controller do 
    type "AWS::IAM::ManagedPolicy"
    properties do
      path "/kubernetes/"
      managed_policy_name "ExternalServiceDiscoveryDnsController"
      description "Policy required for the external DNS kubernetes controller with service discovery"
      policy_document.version '2012-10-17'
      policy_document.statement _array(
        -> {
          effect 'Allow'
          action _array(
            "route53:GetHostedZone",
            "route53:ListHostedZonesByName",
            "route53:CreateHostedZone",
            "route53:DeleteHostedZone",
            "route53:ChangeResourceRecordSets",
            "route53:CreateHealthCheck",
            "route53:GetHealthCheck",
            "route53:DeleteHealthCheck",
            "route53:UpdateHealthCheck",
            "ec2:DescribeVpcs",
            "ec2:DescribeRegions",
            "servicediscovery:*"
          )
          resource '*'
        }
      )
    end
  end
  
  # See https://github.com/kubernetes-sigs/aws-alb-ingress-controller/blob/master/docs/examples/iam-policy.json
  resources.aws_alb_ingress_controller do 
    type "AWS::IAM::ManagedPolicy"
    properties do
      path "/kubernetes/"
      managed_policy_name "AwsAlbIngressController"
      description "Policy required for the aws alb ingress controller"
      policy_document.version '2012-10-17'
      policy_document.statement _array(
        -> {
          effect 'Allow'
          action _array(
            "acm:DescribeCertificate",
          "acm:ListCertificates",
          "acm:GetCertificate"
          )
          resource '*'
        },
        -> {
          effect 'Allow'
          action _array(
            "ec2:AuthorizeSecurityGroupIngress",
            "ec2:CreateSecurityGroup",
            "ec2:CreateTags",
            "ec2:DeleteTags",
            "ec2:DeleteSecurityGroup",
            "ec2:DescribeAccountAttributes",
            "ec2:DescribeAddresses",
            "ec2:DescribeInstances",
            "ec2:DescribeInstanceStatus",
            "ec2:DescribeInternetGateways",
            "ec2:DescribeNetworkInterfaces",
            "ec2:DescribeSecurityGroups",
            "ec2:DescribeSubnets",
            "ec2:DescribeTags",
            "ec2:DescribeVpcs",
            "ec2:ModifyInstanceAttribute",
            "ec2:ModifyNetworkInterfaceAttribute",
            "ec2:RevokeSecurityGroupIngress"
          )
          resource '*'
        },
        -> {
          effect 'Allow'
          action _array(
            "elasticloadbalancing:AddListenerCertificates",
            "elasticloadbalancing:AddTags",
            "elasticloadbalancing:CreateListener",
            "elasticloadbalancing:CreateLoadBalancer",
            "elasticloadbalancing:CreateRule",
            "elasticloadbalancing:CreateTargetGroup",
            "elasticloadbalancing:DeleteListener",
            "elasticloadbalancing:DeleteLoadBalancer",
            "elasticloadbalancing:DeleteRule",
            "elasticloadbalancing:DeleteTargetGroup",
            "elasticloadbalancing:DeregisterTargets",
            "elasticloadbalancing:DescribeListenerCertificates",
            "elasticloadbalancing:DescribeListeners",
            "elasticloadbalancing:DescribeLoadBalancers",
            "elasticloadbalancing:DescribeLoadBalancerAttributes",
            "elasticloadbalancing:DescribeRules",
            "elasticloadbalancing:DescribeSSLPolicies",
            "elasticloadbalancing:DescribeTags",
            "elasticloadbalancing:DescribeTargetGroups",
            "elasticloadbalancing:DescribeTargetGroupAttributes",
            "elasticloadbalancing:DescribeTargetHealth",
            "elasticloadbalancing:ModifyListener",
            "elasticloadbalancing:ModifyLoadBalancerAttributes",
            "elasticloadbalancing:ModifyRule",
            "elasticloadbalancing:ModifyTargetGroup",
            "elasticloadbalancing:ModifyTargetGroupAttributes",
            "elasticloadbalancing:RegisterTargets",
            "elasticloadbalancing:RemoveListenerCertificates",
            "elasticloadbalancing:RemoveTags",
            "elasticloadbalancing:SetIpAddressType",
            "elasticloadbalancing:SetSecurityGroups",
            "elasticloadbalancing:SetSubnets",
            "elasticloadbalancing:SetWebACL"
          )
          resource '*'
        },
        -> {
          effect 'Allow'
          action _array(
            "iam:CreateServiceLinkedRole",
            "iam:GetServerCertificate",
            "iam:ListServerCertificates"
          )
          resource '*'
        },
        -> {
          effect 'Allow'
          action _array(
            "waf-regional:GetWebACLForResource",
            "waf-regional:GetWebACL",
            "waf-regional:AssociateWebACL",
            "waf-regional:DisassociateWebACL"
          )
          resource '*'
        },
        -> {
          effect 'Allow'
          action _array(
            "tag:GetResources",
            "tag:TagResources"
          )
          resource '*'
        },
        -> {
          effect 'Allow'
          action _array(
            "waf:GetWebACL"
          )
          resource '*'
        }
      ) 
    end               
  end

  
  outputs.cluster_autoscaler_policy_id do
    description 'Policy ID for the cluster-autoscaler component'
    value ref!(:cluster_autoscaler)
  end

  outputs.external_dns_controller_policy_id do
    description 'Policy ID for the standard external DNS controller'
    value ref!(:external_dns_controller)
  end

  outputs.external_service_discovery_dns_controller_policy_id do
    description 'Policy ID for the service discovery external DNS controller'
    value ref!(:external_service_discovery_dns_controller)
  end

  outputs.aws_alb_ingress_controller_policy_id do
    description 'Policy ID for the aws alb ingress controller policy'
    value ref!(:aws_alb_ingress_controller)
  end

end
