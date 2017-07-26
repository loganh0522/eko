Fabricator(:company) do 
  name "Talentwiz"
  website {Faker::Internet.domain_name}
end