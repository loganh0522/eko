Fabricator(:education) do 
  school "Queens"
  degree "Commerce"
  current_position 1 
  description {Faker::Lorem.paragraph(2)}
  start_date "May 15 2015"
  end_date "May 15 2015"
end