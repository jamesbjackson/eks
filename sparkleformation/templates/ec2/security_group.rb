SparkleFormation.new(:security_group).load(:base).overrides do
	description "EC2 - Security Group"

		parameters do
			friendly_name do
				description 'The friendly name of the security group'
				registry!(:string_aws_parameter_type)
			end
			group_description do
				description 'Description of the security group.'
				registry!(:string_aws_parameter_type)
			end
			vpc_id do
				description 'The ID of the VPC'
				registry!(:vpc_id_aws_parameter_type)
			end
		end

    resources do
			security_group do
				type 'AWS::EC2::SecurityGroup'
				properties do
					vpc_id ref!(:vpc_id)
					group_description ref!(:group_description)
					tags _array(
						{ Key: 'Name', Value: ref!(:friendly_name) },
					)
				end
			end
    end

    outputs do
        security_group_id do
            description 'The ID of the secruity group'
            value ref!(:security_group)
        end
    end

end
