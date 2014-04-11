class DeviceToken < ActiveRecord::Base
  attr_accessible :expires, :ip, :token

  	belongs_to :user

	def self.generate_token
		Digest::SHA1.hexdigest([Time.now, rand].join)
	end

end
