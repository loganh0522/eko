Fabricator(:client_contact) do 
  first_name {Faker::Name.name}
  last_name {Faker::Name.name}
  email {Faker::Name.name}
  phone {Faker::Name.name}
end