Fabricator(:job) do 
  title "Title"
  location "Toronto, On, Canada"
  address "58 Haddington Ave"
  education_level "High School"
  kind "Full-time"
  career_level "Experienced"
  description {Faker::Lorem.paragraph(2)}
  benefits {Faker::Lorem.paragraph(2)}
end