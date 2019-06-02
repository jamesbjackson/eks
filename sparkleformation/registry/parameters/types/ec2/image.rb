
SfnRegistry.register(:image_id) do
  type "AWS::EC2::Image::Id"
end

SfnRegistry.register(:image_id_array) do
  type "List<AWS::EC2::Image::Id>"
end