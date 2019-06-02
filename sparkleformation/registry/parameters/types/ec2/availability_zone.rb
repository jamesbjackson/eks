
SfnRegistry.register(:availability_zone_name) do
  type "AWS::EC2::AvailabilityZone::Name"
end

SfnRegistry.register(:availability_zone_name_array) do
  type "List<AWS::EC2::AvailabilityZone::Name>"
end