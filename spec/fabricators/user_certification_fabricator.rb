Fabricator(:user_certification) do 
  name {Faker::Name.name}
  agency {Faker::Name.name}
  start_month "May"
  start_year "2017"
  end_month "May"
  end_year  "2020"
end