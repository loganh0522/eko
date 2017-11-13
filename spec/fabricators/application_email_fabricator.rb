Fabricator(:application_email) do 
  subject "Application for Job"
  body {Faker::Lorem.paragraph(1)}
end