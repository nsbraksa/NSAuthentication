if !@user.nil?
	json.id @user.id
	json.name @user.name
	json.email @user.email
	json.bio @user.bio
	json.token @token
end

json.success @success
json.message @message

