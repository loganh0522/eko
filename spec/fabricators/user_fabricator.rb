Fabricator(:user) do 
  email {Faker::Internet.email}
  password 'password'
  first_name {Faker::Name.name}
  last_name {Faker::Name.name}
end
