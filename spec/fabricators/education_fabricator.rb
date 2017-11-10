Fabricator(:education) do 
  school "Queens"
  degree "Commerce"
  description {Faker::Lorem.paragraph(2)}
  start_year "2015"
  start_month "May"
  end_year "2020"
  end_month "September"
end