
SfnRegistry.register(:availability_zone_name) do
  "AWS::EC2::AvailabilityZone::Name"
end

SfnRegistry.register(:availability_zone_name_array) do
  "List<AWS::EC2::AvailabilityZone::Name>"
end