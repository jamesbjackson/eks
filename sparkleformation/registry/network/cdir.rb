
# Common Classless Inter-Domain Routing (CIDR) Ranges
# See https://en.wikipedia.org/wiki/Reserved_IP_addresses


SfnRegistry.register(:cidr_current_network) do
  "0.0.0.0/8"
end

SfnRegistry.register(:cidr_metadata) do
  "169.254.169.254/32"
end

SfnRegistry.register(:cidr_internet) do
  "0.0.0.0/0"
end

SfnRegistry.register(:cidr_10_range) do
  "10.0.0.0/8"
end

SfnRegistry.register(:cidr_172_range) do
  "172.16.0.0/12"
end

SfnRegistry.register(:cidr_192_range) do
  "192.168.0.0/16"
end