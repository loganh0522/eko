Fabricator(:candidate) do 
  email {Faker::Internet.email}
  first_name {Faker::Name.name}
  last_name {Faker::Name.name}
  phone {Faker::PhoneNumber.phone_number}
end