SparkleFormation.new(:route).load(:base).overrides do
    description "EC2 - Route"

    parameters do
        destination_cidr_block do
            description "The CIDR address block used for the destination match"
            type registry!(:string)
            registry!(:cdir_constraint)

        end
       gateway_id do
            description "The ID of an Internet gateway or virtual private gateway that is attached to your VPC"
            type registry!(:string)
            default registry!(:no_value)
        end
        instance_id do
            description "The ID of a NAT instance in your VPC"
            type registry!(:string)
            default registry!(:no_value)
        end
        nat_gateway_id do
            description "The ID of a NAT gateway"
            type registry!(:string)
            default registry!(:no_value)
        end
        network_interface_id do
            description "The ID of an Internet gateway or virtual private gateway that is attached to your VPC"
            type registry!(:string)
            default registry!(:no_value)
        end
        route_table_id do
            description "The ID of the route table where the route will be added"
            type registry!(:string)
        end
        vpc_peering_connection_id do
            description "The ID of a VPC peering connection"
            type registry!(:string)
            default registry!(:no_value)
        end
    end

    conditions do
      is_gateway_id_empty (equals!(ref!(:gateway_id), "AWS::NoValue"))
      is_instance_id_empty (equals!(ref!(:instance_id), "AWS::NoValue"))
      is_nat_gateway_id_empty (equals!(ref!(:nat_gateway_id), "AWS::NoValue"))
      is_network_interface_id_empty (equals!(ref!(:network_interface_id), "AWS::NoValue"))
      is_vpc_peering_connection_id_empty (equals!(ref!(:vpc_peering_connection_id), "AWS::NoValue"))
    end


    resources do
        route do
            type 'AWS::EC2::Route'
            properties do
                destination_cidr_block ref!(:destination_cidr_block)
                gateway_id if!(:is_gateway_id_empty, ref!("AWS::NoValue"), ref!(:gateway_id))
                instance_id if!(:is_instance_id_empty, ref!("AWS::NoValue"), ref!(:instance_id))
                nat_gateway_id if!(:is_nat_gateway_id_empty, ref!("AWS::NoValue"), ref!(:nat_gateway_id))
                network_interface_id if!(:is_network_interface_id_empty, ref!("AWS::NoValue"), ref!(:network_interface_id))
                route_table_id ref!(:route_table_id)
                vpc_peering_connection_id if!(:is_vpc_peering_connection_id_empty, ref!("AWS::NoValue"), ref!(:vpc_peering_connection_id))
           end
        end
    end

    outputs do
        route_id do
            description 'The ID of the new route'
            value ref!(:route)
        end
    end
end
