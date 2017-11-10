Fabricator(:user_avatar) do 
  image {Faker::Name.name}
end