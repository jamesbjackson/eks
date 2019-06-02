
SfnRegistry.register(:db_instance_class_constraint) do
  constraint_description 'Must be a valid AWS RDS instance class'
  allowed_values %w(db.t1.micro db.m1.small db.m1.medium db.m1.large db.m1.xlarge db.m2.xlarge db.m2.2xlarge db.m2.4xlarge db.m3.medium db.m3.large db.m3.xlarge db.m3.2xlarge db.m4.large db.m4.xlarge db.m4.2xlarge db.m4.4xlarge db.m4.10xlarge db.r3.large db.r3.xlarge db.r3.2xlarge db.r3.4xlarge db.r3.8xlarge db.t2.micro db.t2.small db.t2.medium db.t2.large)
end

SfnRegistry.register(:db_instance_engine_constraint) do
  constraint_description 'Must be a valid RDS suppported database engine'
  allowed_values %w(mysql mariadb oracle-se1 oracle-se oracle-ee sqlserver-ee sqlserver-se sqlserver-ex sqlserver-web postgres aurora)
end

SfnRegistry.register(:db_instance_storage_type_constraint) do
  constraint_description 'Must be a supported storage type for AWS RDS service'
  allowed_values %w(standard gp2 io1)
end

SfnRegistry.register(:db_instance_allocated_storage_constraint) do
  max_value 6144
  min_value 5
end

SfnRegistry.register(:db_instance_backup_retention_period_constraint) do
  max_value 35
  min_value 0
end