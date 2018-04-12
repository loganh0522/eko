Fabricator(:question) do 
  body {Faker::Name.name}
  kind "Text (Long Answer)"
end