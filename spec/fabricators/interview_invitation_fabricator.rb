Fabricator(:interview_invitation) do 
  title "Title"
  location "Toronto, On, Canada"
  kind "Phone Interview"
  subject "Experienced"
  message {Faker::Lorem.paragraph(2)}
end