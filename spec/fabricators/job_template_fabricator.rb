Fabricator(:job_template) do 
  title "Title"
  description {Faker::Lorem.paragraph(2)}
end