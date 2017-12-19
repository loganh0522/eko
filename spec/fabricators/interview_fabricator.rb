Fabricator(:interview) do 
  title "Title"
  location "Toronto, On, Canada"
  kind "Phone Interview"
  start_time "12:00pm"
  end_time "1:00pm"
  date {Faker::Date.forward(14)}
  notes {Faker::Lorem.paragraph(2)}
end