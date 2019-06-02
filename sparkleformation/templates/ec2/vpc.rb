SparkleFormation.new(:vpc).load(:base).overrides do
	description "EC2 - Virtual Private Cloud"

	parameters do
		cidr_block do
			description 'The CIDR block you want the VPC to cover'
      type registry!(:string)
      registry!(:cdir_constraint)
		end
		enable_dns_support do
			description 'Specifies whether DNS resolution is supported for the VPC. By default, the value is true.'
			type registry!(:string)
      default registry!(:true)
      registry!(:boolean_constraint)
		end
		enable_dns_hostnames do
			description 'Specifies whether DNS resolution is supported for the VPC.'
			type registry!(:string)
      default registry!(:true)
      registry!(:boolean_constraint)
		end
		friendly_name do
			description 'The friendly name of the VPC'
			type registry!(:string)
		end
		instance_tenancy do
			description 'The allowed tenancy of instances launched into the VPC'
			type registry!(:string)
      default 'default'
      registry!(:instance_tenancy_constraint)
		end
	end

	resources do
	  virtual_private_cloud do
			type 'AWS::EC2::VPC'
			properties do
				cidr_block ref!(:cidr_block)
				enable_dns_support ref!(:enable_dns_support)
				enable_dns_hostnames ref!(:enable_dns_hostnames)
				instance_tenancy ref!(:instance_tenancy)
				tags _array(
	        		{ Key: 'Name', Value: ref!(:friendly_name) },
	      		)
			end
		end
	end

	outputs do
		vpc_id do
			description 'The ID of the newly created Virtual Private Cloud'
			value ref!(:virtual_private_cloud)
		end
		cidr_block do
			description 'The CIDR Block of the newly created Virtual Private Cloud'
			value ref!(:cidr_block)
		end
		region_id do
			description 'The region of the new Virtual Private Cloud'
			value region!()
		end
	end
end
