json.array!(@hiring_team) do |user|
  json.id user.id
  json.name user.full_name
end