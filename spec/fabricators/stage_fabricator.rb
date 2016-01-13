Fabricator(:stage) do 
  name {Faker::Name.name}
  position {Faker::Number.number(1)}
end