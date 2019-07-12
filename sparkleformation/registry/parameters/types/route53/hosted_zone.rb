
SfnRegistry.register(:route53_hosted_zone_id) do
  "AWS::Route53::HostedZone::Id"
end

SfnRegistry.register(:route53_hosted_zone_id_array) do
  "List<AWS::Route53::HostedZone::Id>"
end