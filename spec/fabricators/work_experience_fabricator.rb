Fabricator(:work_experience) do 
  title "Title"
  company_name "Talentwiz"
  current_position 1 
  description {Faker::Lorem.paragraph(2)}
  start_date "May 15 2015"
  end_date "May 15 2015"
end