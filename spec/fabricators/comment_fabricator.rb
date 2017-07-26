Fabricator(:comment) do 
  body {Faker::Lorem.paragraph(1)}
end