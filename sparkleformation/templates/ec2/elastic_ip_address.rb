SparkleFormation.new(:elastic_ip_address).load(:base).overrides do
    description "EC2 - Reserved Static Public IP Addresses"


    resources do 

      ip_address do
        type 'AWS::EC2::EIP'
        properties do
          domain registry!(:elastic_ip_vpc_domain_property_value)
        end
        deletion_policy registry!(:retain_deletion_policy)
      end

  end

  outputs do
    
    ip_address do
      description 'The IP address'
      value ref!(:ip_address)
    end
    allocation_id do
      description 'The allociation id of the IP address '
      value attr!(:ip_address, :allocation_id)
    end

  end

end
