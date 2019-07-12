
SfnRegistry.register(:security_group_name) do
  "AWS::EC2::SecurityGroup::GroupName"
end

SfnRegistry.register(:security_group_name_array) do
  "List<AWS::EC2::SecurityGroup::GroupName>"
end

SfnRegistry.register(:security_group_id) do
  "AWS::EC2::SecurityGroup::Id"
end

SfnRegistry.register(:security_group_id_array) do
  "List<AWS::EC2::SecurityGroup::Id>"
end