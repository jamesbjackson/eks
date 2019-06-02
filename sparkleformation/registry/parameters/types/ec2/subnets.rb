
SfnRegistry.register(:subnet_id) do
  type "AWS::EC2::Subnet::Id"
end

SfnRegistry.register(:subnet_id_array) do
  type "List<AWS::EC2::Subnet::Id>"
end