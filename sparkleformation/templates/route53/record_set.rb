SparkleFormation.new(:record_set).load(:base).overrides do
    description "Route53 - Record Set"

    parameters do
        hosted_zone_domain_name do
            description "The hosted zone domain name."
            registry!(:string_aws_parameter_type)
        end
        hosted_zone_id do
            description "The ID of the hosted zone to create the DNS record."
            registry!(:route53_hosted_zone_id_aws_parameter_type)
        end
        subdomain do
            description "The name of the subdomain"
            registry!(:string_aws_parameter_type)
        end
        resource_records do
            description "A list of resource records"
            registry!(:comma_delimited_list_aws_parameter_type)
        end
        ttl do
            description "The cache time to live (TTL), in seconds."
            registry!(:number_aws_parameter_type)
        end
        type do
            description "The type of DNS records to add."
            registry!(:route53_resource_record_type_parameter_constraint)
            registry!(:string_aws_parameter_type)
        end
    end

    resources do
        route53_record_set do
         type 'AWS::Route53::RecordSet'
         properties do
           hosted_zone_id ref!(:hosted_zone_id)
           name join!(ref!(:subdomain), ".", ref!(:hosted_zone_domain_name), '.')
           resource_records ref!(:resource_records)
           type ref!(:type)
           t_t_l ref!(:ttl)
         end
       end
    end

    outputs do
       domain_name do
         description 'The domain name'
         value ref!(:route53_record_set)
       end
    end
end
