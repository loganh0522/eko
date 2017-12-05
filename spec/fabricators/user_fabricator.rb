Fabricator(:user) do 
  email {Faker::Internet.email}
  password 'password'
  phone '4168066907'
  first_name {Faker::Name.name}
  last_name {Faker::Name.name}
end
