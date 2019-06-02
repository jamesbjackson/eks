
SfnRegistry.register(:instance_id) do
  type "AWS::EC2::Instance::Id"
end

SfnRegistry.register(:instance_id_array) do
  type "List<AWS::EC2::Instance::Id>"
end