SparkleFormation.new(:internet_gateway).load(:base).overrides do
	description "EC2 - Internet Gateway"

	parameters do
		friendly_name do
			description 'The friendly name of the Internet Gateway'
			type registry!(:string)
    end
    vpc_id do
			description 'The ID of the VPC'
			type registry!(:vpc_id)
		end
	end

	resources do
	  internet_gateway do
			type 'AWS::EC2::InternetGateway'
			properties do
				tags _array(
          { Key: 'Name', Value: ref!(:friendly_name) }
        )
			end
    end
    vpc_gateway_attachment do
			type 'AWS::EC2::VPCGatewayAttachment'
			properties do
				internet_gateway_id ref!(:internet_gateway)
				vpc_id ref!(:vpc_id)
      end
    end  
	end

	outputs do
		internet_gateway_id do
			description 'The ID of the newly created Internet Gateway'
			value ref!(:internet_gateway)
    end
    vpc_gateway_attachment_id do
			description 'The ID of the VPC Gateway Attachment'
			value ref!(:vpc_gateway_attachment)
		end
	end
end
