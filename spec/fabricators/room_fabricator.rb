Fabricator(:room) do 
  name "Room"
  email {Faker::Internet.email}
end