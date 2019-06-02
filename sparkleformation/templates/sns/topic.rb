SparkleFormation.new(:simple_notification_service_email_topic).load(:base).overrides do
    description "SNS - Alarm Notification Topic "

    parameters do
       display_name  do
           description "A developer-defined string that can be used to identify this SNS topic."
           registry!(:string_aws_parameter_type)
       end
       primary_email_address  do
            description "The primary email address to send the notifications"
            registry!(:string_aws_parameter_type)
        end
    end

    resources do
      topic do
        type 'AWS::SNS::Topic'
        properties do
          display_name ref!(:display_name)
          subscription([
            {Endpoint: ref!(:primary_email_address), Protocol: 'email'}
          ])
        end
      end
    end

    outputs do
      topic_arn do
        description 'The ARN of the SNS Topic'
        value ref!(:topic)
      end
      topic_name do
        description 'The CloudFormation unique physical ID used as the topic name'
        value attr!(:topic, :topic_name)
      end
    end
end
