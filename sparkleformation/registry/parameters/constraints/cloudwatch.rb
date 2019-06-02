
# See http://docs.aws.amazon.com/AmazonCloudWatchLogs/latest/APIReference/API_PutRetentionPolicy.html
SfnRegistry.register(:cloudwatch_log_retention_days_constraint) do
  constraint_description 'Must be one of the acceptable data ranges'
  allowed_values %w(1 3 5 7 14 30 60 90 120 150 180 365 400 545 731 1827 3653)
end