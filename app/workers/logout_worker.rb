class LogoutWorker
	include Sidekiq::Worker

	def perform user_id
		user = User.find user_id
		puts "tried" * 100
		user.update_attributes active: false
		
		if (Time.now - 1.seconds) > user.updated_at
			user.update_attributes active: false
			puts "tried again" * 100
		end
	end
end