Fabricator(:email_template) do 
  title "Rejection E-mail"
  subject "Application for Job"
  body {Faker::Lorem.paragraph(2)}
end