
SfnRegistry.register(:route53_resource_record_type_constraint) do
  constraint_description 'Must be a supported DNS record type'
  allowed_values %w(A AAAA CNAME MX NS PTR SOA SPF SRV TXT)
end