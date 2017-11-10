Fabricator(:work_experience) do 
  title "Title"
  company_name "Talentwiz"
  current_position 1 
  description {Faker::Lorem.paragraph(2)}
  start_year "2015"
  end_year "2016"
  start_month "May"
  end_month "June"
end