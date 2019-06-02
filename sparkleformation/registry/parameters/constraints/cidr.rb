
SfnRegistry.register(:cdir_constraint) do
  constraint_description 'Must be a valid IP CIDR range of the form x.x.x.x/x'
  allowed_pattern '^([0-9]{1,3}\.){3}[0-9]{1,3}(\/([0-9]|[1-2][0-9]|3[0-2]))?$'
  min_length "9"
  max_length "18"
end
