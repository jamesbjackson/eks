SparkleFormation.new(:vpc_private_hosted_zone, compile_time_parameters: {
  vpcs: {type: :string, multiple: true},
  vpc_regions: {type: :string, multiple: true},
}).load(:template_base).overrides do
  description "Route53 - Hosted Zone"

  raise(ArgumentError, "Unequal number of VPCs and regions") if state!(:vpcs).length != state!(:vpc_regions).length

  parameters.domain_name do
    description "The name of the domain"
    registry!(:string_aws_parameter_type)
  end

  allowed_vpcs = state!(:vpcs).each_with_index.collect do |vpc, idx|
    {VPCId: vpc, VPCRegion: state!(:vpc_regions)[idx] }
  end

  resources.hosted_zone do
    type 'AWS::Route53::HostedZone'
    properties do
      name ref!(:domain_name)
      v_p_cs allowed_vpcs
    end
  end

  outputs do
    hosted_zone_id do
      description 'The ID of the new hosted zone'
      value ref!(:hosted_zone)
    end
    domain_name do
      description 'The domain name of the new hosted zone'
      value ref!(:domain_name)
    end
  end
end
