
# See http://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#CannedACL.html
SfnRegistry.register(:s3_bucket_access_control_constraint) do
  constraint_description 'Must be a valid AWS S3 Canned Access Control List (ACL) value'
  allowed_values %w(AuthenticatedRead AwsExecRead BucketOwnerRead BucketOwnerFullControl LogDeliveryWrite Private PublicRead PublicReadWrite)
end

# See http://docs.aws.amazon.com/AmazonS3/latest/API/RESTBucketPUTVersioningStatus.html
SfnRegistry.register(:s3_bucket_versioning_constraint) do
  constraint_description 'Must be either Enabled or Suspended'
  allowed_values %w(Enabled Suspended)
end