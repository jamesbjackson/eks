
# Deletion Policy Attribute
# See http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-attribute-deletionpolicy.html


SfnRegistry.register(:delete_deletion_policy) do
  "Delete"
end

SfnRegistry.register(:retain_deletion_policy) do
  "Retain"
end

SfnRegistry.register(:snapshot_deletion_policy) do
  "Snapshot"
end
