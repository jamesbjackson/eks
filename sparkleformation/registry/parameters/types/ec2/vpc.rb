
SfnRegistry.register(:vpc_id) do
  type "AWS::EC2::VPC::Id"
end

SfnRegistry.register(:vpc_id_array) do
  type "List<AWS::EC2::VPC::Id>"
end