SparkleFormation.new(:eks_worker_nodes_asg, compile_time_parameters: {
  group_tags: { type: :string, multiple: true }
  }).load(:base).overrides do
  description "EC2 - EKS Worker Nodes ASG"

  parameters.cluster_name do
    description 'The name of the EKS Cluster'
    registry!(:string_aws_parameter_type)
  end

  parameters.group_name do
    description 'The worker group name'
    registry!(:string_aws_parameter_type)
    default 'eks-cluster'
  end

  parameters.bootstrap_arguments do
    description 'Arguments to pass to the bootstrap script. See files/bootstrap.sh in https://github.com/awslabs/amazon-eks-ami'
    registry!(:string_aws_parameter_type)
    default ""
  end

  parameters.root_volume_size do
    description 'size of root ebs volume'
    registry!(:string_aws_parameter_type)
    default '100'
  end

  parameters.image_id do
      description "The unique ID of the Amazon Machine Image (AMI) to be used by this instance"
      registry!(:image_id_aws_parameter_type)
  end

  parameters.instance_type do
    description 'instance type'
    registry!(:string_aws_parameter_type)
    default 't3.medium'
  end

  parameters.key_name do
    description 'keypair to use for instance'
    registry!(:string_aws_parameter_type)
  end

  parameters.monitoring do
    description 'boolean to decide monitoring'
    registry!(:boolean_parameter_constraint)
    registry!(:string_aws_parameter_type)
    registry!(:true_parameter_default)
  end

  parameters.ebs_optimized do
      description "Is the instance type selected optimized for Amazon Elastic Block Store I/O"
      registry!(:string_aws_parameter_type)
      registry!(:boolean_parameter_constraint)
      registry!(:false_parameter_default)
  end

  parameters.max_size do
    description 'Max number of instances in the AS Group'
    registry!(:string_aws_parameter_type)
    default '5'
  end

  parameters.min_size do
    description 'Minimum number of instances in the AS Group'
    registry!(:string_aws_parameter_type)
    default '1'
  end

  parameters.security_groups do
    description 'ID of the security groups to use'
    registry!(:comma_delimited_list_aws_parameter_type)
  end

  parameters.subnets do
    description 'ID of the subnets to use'
    registry!(:comma_delimited_list_aws_parameter_type)
  end

  parameters.instance_profile do
    description 'ID of the instance profile to be used'
    registry!(:string_aws_parameter_type)
  end

  parameters.sns_topic do
    description 'The SNS topic ID to be used'
    registry!(:string_aws_parameter_type)
  end

  asg_tags = [
    { Key: 'Name', Value: join!( ref!(:cluster_name), "-", ref!(:group_name), "-node" ), PropagateAtLaunch: 'true' },
    { Key: join!("kubernetes.io/cluster/", ref!(:cluster_name)), Value: 'owned', PropagateAtLaunch: 'true' },
    { Key: join!("k8s.io/cluster-autoscaler/", ref!(:cluster_name)), Value: 'owned', PropagateAtLaunch: 'true' },
    { Key: 'k8s.io/cluster-autoscaler/enabled', Value: 'true', PropagateAtLaunch: 'true' }
  ]
  state!(:group_tags).each do |tag|
    name, val = tag.split('=')
    asg_tags << {Key: name, Value: val, PropagateAtLaunch: 'true'}
  end

  resources.auto_scaling_group do
    type 'AWS::AutoScaling::AutoScalingGroup'
    properties do
      cooldown '60'
      health_check_type 'EC2'
      health_check_grace_period '300'
      launch_configuration_name ref!(:launch_configuration)
      max_size ref!(:max_size)
      metrics_collection _array( { Granularity: '1Minute'} )
      min_size ref!(:min_size)
      VPCZoneIdentifier ref!(:subnets)
      NotificationConfigurations _array({
        TopicARN: ref!(:sns_topic),
        NotificationTypes: [
          "autoscaling:EC2_INSTANCE_LAUNCH",
          "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
          "autoscaling:EC2_INSTANCE_TERMINATE",
          "autoscaling:EC2_INSTANCE_TERMINATE_ERROR"
        ]
      })
      tags asg_tags
    end
    creation_policy do
      resource_signal do
        count ref!(:min_size)
        timeout 'PT90M'
      end
    end
    update_policy do
      auto_scaling_rolling_update do
        max_batch_size 1 
        min_instances_in_service ref!(:min_size)
        pause_time 'PT5M'
      end
    end
    depends_on!(
      :launch_configuration
    )
  end

  resources.launch_configuration do
    type 'AWS::AutoScaling::LaunchConfiguration'
    properties do
      block_device_mappings _array(
        {
          DeviceName: '/dev/xvda',
          Ebs: { VolumeSize: ref!(:root_volume_size), VolumeType: 'gp2', DeleteOnTermination: true }
        },
      )
      ebs_optimized ref!(:ebs_optimized)
      iam_instance_profile ref!(:instance_profile)
      image_id ref!(:image_id)
      instance_type ref!(:instance_type)
      key_name ref!(:key_name)
      associate_public_ip_address true
      instance_monitoring ref!(:monitoring)
      security_groups ref!(:security_groups)
      user_data base64!(
        join!(
          "#!/bin/bash -x", "\n",
          "set -o xtrace", "\n",
          "/etc/eks/bootstrap.sh ", ref!(:cluster_name), " ", ref!(:bootstrap_arguments), "\n",
          "/opt/aws/bin/cfn-signal --exit-code $? --region ", ref!('AWS::Region'), " --stack ", ref!('AWS::StackName'), " --resource AutoScalingGroup", "\n",
        )
      )
    end
  end

  resources.health_check_alarm do
    Type 'AWS::CloudWatch::Alarm'
    Properties do
      AlarmDescription 'alarm for health check failure'
      AlarmActions _array(
        ref!(:sns_topic)
      )
      MetricName 'StatusCheckFailed'
      Namespace 'AWS/EC2'
      Statistic 'Minimum'
      Period '60'
      EvaluationPeriods '5'
      Threshold '0'
      ComparisonOperator 'GreaterThanThreshold'
      Dimensions _array(
        { Name: 'AutoScalingGroupName', Value: ref!(:auto_scaling_group) }
      )
    end
    depends_on!(
      :auto_scaling_group
    )
  end

  outputs.asg_id do
    description 'ID of the AutoScaling Group'
    value ref!(:auto_scaling_group)
  end

end
