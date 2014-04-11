class Api::UsersController < ApplicationController

	#before_filter :restrict_access_for_a_valid_token , :except => [:auth, :register, :facebook]
	respond_to :json
	skip_before_filter :verify_authenticity_token

	def index
		@users = User.all
	end

	def show 
		token = request.headers['token']
		@user = DeviceToken.find_by_token(token).user
	end

	def register
		#render json: params
		#return 

		# params = { name, email, passowrd }
		@user = User.new(params[:user])

		if @user.save
			# generate device token for newly created user
			new_token = DeviceToken.create(token: DeviceToken.generate_token, expires: Time.now + (8*7*24*60*60))
			@user.device_tokens << new_token
			@token = new_token.token

			# set up variables for json
			@message = "Account successfully created"
			@success = true
		else
			# set up variables for json
			@success = false
			@message = @user.errors
		end
	end

	def auth
		#render :text => params.to_json
		#return 

		@errors = Array.new

		if params[:login].nil?
			@errors.push("Login not found")
		end
		if params[:password].nil?
			@errors.push("Password not found")
		end

		email = params[:login]
		password = params[:password]

		user = User.where(email: email.downcase).first


		### if cases ###
		# case 1 : Handle when there was no email and/or password 
		# case 2 : handle when email/password were correct 
		# case 3 : handle when email/password were present but incorrect  
		if !@errors.empty? #is errors not empty
			@success = false
			@message = "[API] Make sure there is an email and a password params"
		elsif user and user.valid_password?(password)
			device_token = DeviceToken.create(token: DeviceToken.generate_token, expires: Time.now + (8*7*24*60*60))
			user.device_tokens << device_token

			@user = user
			@success = true
			@token = device_token.token 
			@message = "User successfully authenticated"

		else
			@success = false
			@message = "Incorrect email/password combination"
		end
	end

	def update 
		@success = false
		token = request.headers['token']
		@user = DeviceToken.find_by_token(token).user

		if @user.id == params[:user_id].to_i
			@user.update_attributes(params[:user])
			@success = true
		else 
			@success = false
			@message = "There seem to be a serious mistake, Please try again in a year or two!"
		end
	end

	# def disconnect
	# 	apn_devices = APN::Device.where(:token => params[:device_token])
	# 	@message = "#{apn_devices.count} Device successfully disconnected"
	# 	apn_devices.each do |apn_device|
	# 		Device.where(:device_id => apn_device.id).destroy_all
	# 		apn_device.destroy
	# 	end

	# 	@success = true 
	# end
	

end