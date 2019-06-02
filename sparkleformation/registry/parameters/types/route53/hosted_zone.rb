
SfnRegistry.register(:route53_hosted_zone_id) do
  type "AWS::Route53::HostedZone::Id"
end

SfnRegistry.register(:route53_hosted_zone_id_array) do
  type "List<AWS::Route53::HostedZone::Id>"
end