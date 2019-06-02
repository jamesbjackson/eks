SparkleFormation.dynamic(:subnet_with_route_table_association) do |_name, _config={}|
  subnet_name = "#{_name}_subnet"

  parameters do
    set!("#{subnet_name}_availability_zone_letter".to_sym) do
      description "The availability zone letter in which you want the subnet."
      registry!(:string_aws_parameter_type)
    end
    set!("#{subnet_name}_cidr_block".to_sym) do
      description "The CIDR block that you want the subnet to cover"
      registry!(:cdir_parameter_constraint)
      registry!(:string_aws_parameter_type)
    end
    set!("#{subnet_name}_friendly_name".to_sym) do
      description "The friendly name of the Subnet"
      registry!(:string_aws_parameter_type)
    end
    set!("#{subnet_name}_map_public_ip_on_launch".to_sym) do
      description "Indicates whether instances that are launched in this subnet receive a public IP address. By default the value is false."
      registry!(:boolean_parameter_constraint)
      registry!(:string_aws_parameter_type)
      default _config[:map_public_ip_on_launch] || 'false'
    end
    set!("#{subnet_name}_route_table_id".to_sym) do
      description "The ID of the route tablet"
      registry!(:string_aws_parameter_type)
    end
    set!("#{subnet_name}_vpc_id".to_sym) do
      description "The ID of the VPC"
      registry!(:vpc_id_aws_parameter_type)
    end
  end

  resources(subnet_name.to_sym) do
    type 'AWS::EC2::Subnet'
    properties do
      availability_zone join!( ref!("AWS::Region"), ref!("#{subnet_name}_availability_zone_letter".to_sym) )
      cidr_block ref!("#{subnet_name}_cidr_block".to_sym)
      map_public_ip_on_launch ref!("#{subnet_name}_map_public_ip_on_launch".to_sym)
      tags _array(
        { Key: 'Name', Value: ref!("#{subnet_name}_friendly_name".to_sym) }
      )
      vpc_id ref!("#{subnet_name}_vpc_id".to_sym)
    end
  end
  resources("#{subnet_name}_route_table_association".to_sym) do
    type 'AWS::EC2::SubnetRouteTableAssociation'
    properties do
      route_table_id ref!("#{subnet_name}_route_table_id".to_sym)
      subnet_id ref!(subnet_name.to_sym)
    end
    depends_on depends_on!(subnet_name.to_sym)
  end

  outputs do
    set!("#{subnet_name}_availability_zone".to_sym) do
      description 'The availability zone holding the subnet'
      value join!( ref!("AWS::Region"), ref!("#{subnet_name}_availability_zone_letter".to_sym) )
    end
    set!("#{subnet_name}_cidr_block".to_sym) do
      description 'The cdir range of the subnet'
      value ref!("#{subnet_name}_cidr_block".to_sym)
    end
    set!("#{subnet_name}_id".to_sym) do
      description 'The id of the subnet'
      value ref!(subnet_name.to_sym)
    end
    set!("#{subnet_name}_route_table_association_id".to_sym) do
      description 'The id of the subnet routing table association'
      value ref!("#{subnet_name}_route_table_association".to_sym)
    end
  end
end
