
SfnRegistry.register(:volume_id) do
  type "AWS::EC2::Volume::Id"
end
  
SfnRegistry.register(:volume_id_array) do
  type "List<AWS::EC2::Volume::Id>"
end