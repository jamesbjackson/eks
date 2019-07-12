
SfnRegistry.register(:subnet_id) do
  "AWS::EC2::Subnet::Id"
end

SfnRegistry.register(:subnet_id_array) do
  "List<AWS::EC2::Subnet::Id>"
end