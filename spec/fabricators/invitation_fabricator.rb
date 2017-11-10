Fabricator(:invitation) do 
  recipient_email { Faker::Internet.email }
  message {Faker::Lorem.paragraph(1)}
  user_role "admin"
end