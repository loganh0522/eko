Fabricator(:location) do 
  name {Faker::Name.name}
  address {Faker::Address.street_name}
  country {Faker::Address.country}
  state {Faker::Address.state}
  city {Faker::Address.city}
  number {Faker::Number.number(4)}
end