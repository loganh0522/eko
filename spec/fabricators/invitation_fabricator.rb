Fabricator(:invitation) do 
  recipient_email { Faker::Internet.email }
end