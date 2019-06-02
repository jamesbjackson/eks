
# See http://docs.aws.amazon.com/ElasticLoadBalancing/latest/DeveloperGuide/elb-security-policy-table.html
SfnRegistry.register(:predefined_elb_ssl_security_policies_constraint) do
  constraint_description 'Must be a supported AWS  SSL security policy for elastic load balancers'
  allowed_values %w(ELBSecurityPolicy-2016-08 ELBSecurityPolicy-2015-05 ELBSecurityPolicy-2015-03 ELBSecurityPolicy-2015-02 ELBSecurityPolicy-2014-10 ELBSecurityPolicy-2014-01 ELBSecurityPolicy-2011-08)
end