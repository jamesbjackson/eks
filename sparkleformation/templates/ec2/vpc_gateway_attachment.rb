SparkleFormation.new(:vpc_gateway_attachment).load(base).overrides do
	description "EC2 -VPC Gateway Attachment"

	parameters do
		internet_gateway_id do
			description 'The ID of the Internet gateway'
			registry!(:aws_no_value_parameter_default)
			registry!(:string_aws_parameter_type)
		end
		vpc_id do
			description 'The ID of the VPC'
			registry!(:vpc_id_aws_parameter_type)
		end
		vpn_gateway_id do
			description 'The ID of the virtual private network (VPN) gateway to attach to the VPC.'
			registry!(:aws_no_value_parameter_default)
			registry!(:string_aws_parameter_type)
		end
	end

	conditions do
  	is_internet_gateway_id_empty (equals!(ref!(:internet_gateway_id), "AWS::NoValue"))
		is_vpn_gateway_id_empty (equals!(ref!(:VpnGatewayId), "AWS::NoValue"))
	end

	resources do
	  vpc_gateway_attachment do
			type 'AWS::EC2::VPCGatewayAttachment'
			properties do
				internet_gateway_id if!(:is_internet_gateway_id_empty, ref!("AWS::NoValue"), ref!(:internet_gateway_id))
				vpc_id ref!(:vpc_id)
				vpn_gateway_id if!(:is_vpn_gateway_id_empty, ref!("AWS::NoValue"), ref!(:vpn_gateway_id))
			end
		end
	end

	outputs do
		vpc_gateway_attachment_id do
			description 'The ID of the VPC Gateway Attachment'
			value ref!(:vpc_gateway_attachment)
		end
	end
end
