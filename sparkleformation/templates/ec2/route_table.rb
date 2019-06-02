SparkleFormation.new(:route_table).load(:base).overrides do
	description "EC2 - Route Table"

	parameters do
		friendly_name do
		  description 'The friendly name of the routing table'
		  type registry!(:string)
		end
		vpc_id do
			description 'The ID of the VPC'
			type registry!(:vpc_id)
		end
	end

	resources do
	  route_table do
			type 'AWS::EC2::RouteTable'
			properties do
				vpc_id ref!(:vpc_id)
        tags _array(
	      	{ Key: 'Name', Value: ref!(:friendly_name) },
	    	)
			end
		end
	end

	outputs do
		route_table_id do
			description 'The ID of the Route Table'
			value ref!(:route_table)
		end
	end
end
