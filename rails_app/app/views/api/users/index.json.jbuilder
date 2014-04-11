json.array! @users do |user|
  json.name user.name
  json.name user.bio
  json.id user.id
end