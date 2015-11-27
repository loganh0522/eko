Fabricator(:job_posting) do 
  name {Faker::Name.name}
  address {Faker::Address.street_address}
  country {Faker::Address.country}
  city {Faker::Address.city}
  state {Faker::Address.state}
  number {Faker::Number.number(3)}
end