
SfnRegistry.register(:vpc_id) do
  "AWS::EC2::VPC::Id"
end

SfnRegistry.register(:vpc_id_array) do
  "List<AWS::EC2::VPC::Id>"
end