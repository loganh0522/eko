json.array!(@users) do |user|
  json.full_name user.full_name
  json.email user.email
end 