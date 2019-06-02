
SfnRegistry.register(:security_group_name) do
  type "AWS::EC2::SecurityGroup::GroupName"
end

SfnRegistry.register(:security_group_name_array) do
  type "List<AWS::EC2::SecurityGroup::GroupName>"
end

SfnRegistry.register(:security_group_id) do
  type "AWS::EC2::SecurityGroup::Id"
end

SfnRegistry.register(:security_group_id_array) do
  type "List<AWS::EC2::SecurityGroup::Id>"
end