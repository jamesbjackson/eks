SparkleFormation.new(:bucket, compile_time_parameters: {
  allow_elb_writes_from_region: {type: :string, default: ''},
  access_log_path: {type: :string, default: ''},
}).load(:template_base).overrides do
  description "S3 - Bucket"

  parameters do
    access_control do
      description 'access control list (ACL) that grants predefined permissions to the bucket.'
      registry!(:s3_bucket_access_control_parameter_constraint)
      registry!(:string_aws_parameter_type)
      registry!(:s3_bucket_access_control_parameter_default)
    end
    bucket_name do
      description 'A unique name for the bucket'
      registry!(:string_aws_parameter_type)
    end
    versioning_state do
      description 'The versioning state of the bucket.'
      registry!(:s3_bucket_versioning_parameter_constraint)
      registry!(:string_aws_parameter_type)
      registry!(:s3_bucket_versioning_parameter_default)
    end
  end

  resources.s3_bucket do
    type 'AWS::S3::Bucket'
    properties do
      access_control ref!(:access_control)
      bucket_name ref!(:bucket_name)
      versioning_configuration Hash[status: ref!(:versioning_state)]
    end
  end

  if !state!(:allow_elb_writes_from_region).blank?
    # http://docs.aws.amazon.com/elasticloadbalancing/latest/classic/enable-access-logs.html#attach-bucket-policy
    acct_ids = {
      "us-east-1"       => "127311923021",
      "us-east-2"       => "033677994240",
      "us-west-1"       => "027434742980",
      "us-west-2"       => "797873946194",
      "ca-central-1"    => "985666609251",
      "eu-west-1"       => "156460612806",
      "eu-central-1"    => "054676820928",
      "eu-west-2"       => "652711504416",
      "ap-northeast-1"  => "582318560864",
      "ap-northeast-2"  => "600734575887",
      "ap-southeast-1"  => "114774131450",
      "ap-southeast-2"  => "783225319266",
      "ap-south-1"      => "718504428378",
      "sa-east-1"       => "507241528517",
      "us-gov-west-1"   => "048591011584",
      "cn-north-1"      => "638102146993",
    }
    dynamic!(:s3_bucket_policy, 'elb_logs', {
      bucket: ref!(:s3_bucket),
      policy_document: {
        "Statement" => [
          {
            "Effect" => "Allow",
            "Action" => %w(s3:PutObject),
            "Resource" => join!("", "arn:aws:s3:::", ref!(:bucket_name), "#{state!(:access_log_path)}/*"),
            "Principal" => {
              "AWS" => acct_ids[state!(:allow_elb_writes_from_region)]
            },
          },
        ]
      }
    })
  end

  outputs do
    bucket_name do
      description 'The unique name of the S3 bucket'
      value ref!(:s3_bucket)
    end
    domain_name do
      description ' the DNS name of the bucket.'
      value attr!(:s3_bucket, "DomainName")
    end
    website_url do
      description ' the DNS name of the bucket.'
      value attr!(:s3_bucket, "WebsiteURL")
    end
  end
end
