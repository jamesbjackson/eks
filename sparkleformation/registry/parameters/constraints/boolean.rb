
SfnRegistry.register(:boolean_constraint) do
  constraint_description 'Must be either true or false'
  allowed_values %w(true false)
end

