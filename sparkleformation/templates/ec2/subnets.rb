SparkleFormation.new(:subnets, compile_time_parameters: {
  resource_name: { type: :string, multiple: true },
  availability_zone: { type: :string, multiple: true },
  cidr_block: { type: :string, multiple: true },
  friendly_name: { type: :string, multiple: true },
  map_public_ip_on_launch: { type: :string, multiple: true },
  route_table_id: { type: :string, multiple: true },
  vpc_id: { type: :string, multiple: true },
  tags: { type: :string, multiple: true }
}).load(:base).overrides do
description "EC2 - Subnets"

  state!(:resource_name).each_with_index do |name, i|
  
    subnet_name = state!(:resource_name)[i]
    availability_zone = state!(:availability_zone)[i]
    cidr_block = state!(:cidr_block)[i]
    friendly_name = state!(:friendly_name)[i]
    map_public_ip_on_launch = state!(:map_public_ip_on_launch)[i]
    route_table_id = state!(:route_table_id)[i]
    vpc_id = state!(:vpc_id)[i]

    subnet_tags = [] 
    subnet_tags << {Key: "Name", Value: friendly_name}

    state!(:tags).each do |tag|
      name, val = tag.split('=')
      subnet_tags << {Key: name, Value: val}
    end

    resources do
      set!("#{subnet_name}".to_sym) do
        type 'AWS::EC2::Subnet'
        properties do
          availability_zone availability_zone
          cidr_block cidr_block
          map_public_ip_on_launch map_public_ip_on_launch
          tags subnet_tags
          vpc_id vpc_id
        end
      end
      set!("#{subnet_name}_route_table_association".to_sym) do
        type 'AWS::EC2::SubnetRouteTableAssociation'
        properties do
          route_table_id route_table_id
          subnet_id ref!(subnet_name.to_sym)
        end
        depends_on depends_on!(subnet_name.to_sym)
      end
    end  
  
    outputs do
      set!("#{subnet_name}_availability_zone".to_sym) do
        description 'The availability zone holding the subnet'
        value availability_zone
      end
      set!("#{subnet_name}_cidr_block".to_sym) do
        description 'The cdir range of the subnet'
        value cidr_block
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

    i =+ 1

  end
end
