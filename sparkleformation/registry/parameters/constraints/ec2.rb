
SfnRegistry.register(:instance_tenancy_constraint) do
  constraint_description 'Must be either default or dedicated'
  allowed_values %w(default dedicated)
end

SfnRegistry.register(:initiated_shutdown_behavior_constraint) do
  constraint_description 'Must be either stop or terminate'
  allowed_values %w(stop terminate)
end

SfnRegistry.register(:instance_type_constraint) do
  constraint_description 'Must be a valid EC2 instance type'
  allowed_values %w( a1.2xlarge a1.4xlarge a1.large a1.medium a1.xlarge c1.medium c1.xlarge c3.2xlarge c3.4xlarge c3.8xlarge c3.large c3.xlarge c4.2xlarge c4.4xlarge c4.8xlarge c4.large c4.xlarge c5.18xlarge c5.2xlarge c5.4xlarge c5.9xlarge c5.large c5.xlarge c5d.18xlarge c5d.2xlarge c5d.4xlarge c5d.9xlarge c5d.large c5d.xlarge c5n.18xlarge c5n.2xlarge c5n.4xlarge c5n.9xlarge c5n.large c5n.xlarge cc2.8xlarge cr1.8xlarge d2.2xlarge d2.4xlarge d2.8xlarge d2.xlarge f1.16xlarge f1.2xlarge f1.4xlarge g2.2xlarge g2.8xlarge g3.16xlarge g3.4xlarge g3.8xlarge g3s.xlarge h1.16xlarge h1.2xlarge h1.4xlarge h1.8xlarge hs1.8xlarge i2.2xlarge i2.4xlarge i2.8xlarge i2.xlarge i3.16xlarge i3.2xlarge i3.4xlarge i3.8xlarge i3.large i3.metal i3.xlarge m1.large m1.medium m1.small m1.xlarge m2.2xlarge m2.4xlarge m2.xlarge m3.2xlarge m3.large m3.medium m3.xlarge m4.10xlarge m4.16xlarge m4.2xlarge m4.4xlarge m4.large m4.xlarge m5.12xlarge m5.24xlarge m5.2xlarge m5.4xlarge m5.large m5.xlarge m5a.12xlarge m5a.24xlarge m5a.2xlarge m5a.4xlarge m5a.large m5a.xlarge m5d.12xlarge m5d.24xlarge m5d.2xlarge m5d.4xlarge m5d.large m5d.xlarge p2.16xlarge p2.8xlarge p2.xlarge p3.16xlarge p3.2xlarge p3.8xlarge p3dn.24xlarge r3.2xlarge r3.4xlarge r3.8xlarge r3.large r3.xlarge r4.16xlarge r4.2xlarge r4.4xlarge r4.8xlarge r4.large r4.xlarge r5.12xlarge r5.24xlarge r5.2xlarge r5.4xlarge r5.large r5.xlarge r5a.12xlarge r5a.24xlarge r5a.2xlarge r5a.4xlarge r5a.large r5a.xlarge r5d.12xlarge r5d.24xlarge r5d.2xlarge r5d.4xlarge r5d.large r5d.xlarge t1.micro t2.2xlarge t2.large t2.medium t2.micro t2.nano t2.small t2.xlarge t3.2xlarge t3.large t3.medium t3.micro t3.nano t3.small t3.xlarge u-12tb1 u-6tb1 u-9tb1 x1.16xlarge x1.32xlarge x1e.16xlarge x1e.2xlarge x1e.32xlarge x1e.4xlarge x1e.8xlarge x1e.xlarge z1d.12xlarge z1d.2xlarge z1d.3xlarge z1d.6xlarge z1d.large z1d.xlarge )
end