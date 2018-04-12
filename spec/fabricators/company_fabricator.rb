Fabricator(:company) do 
  name "Talentwiz"
  website {Faker::Internet.domain_name}
  size "1-20"
  location "Toronto, On, Canada"
end