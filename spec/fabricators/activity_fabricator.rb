Fabricator(:activity) do 
  title "Title"
  country "Country"
  province "province"
  city "city"
  description {Faker::Lorem.paragraph(2)}
  benefits {Faker::Lorem.paragraph(2)}
end