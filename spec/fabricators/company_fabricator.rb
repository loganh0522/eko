Fabricator(:company) do 
  name {Faker::Name.name}
  website {Faker::Internet.domain_name}
end