class MessageMailerWorker
	include Sidekiq::Worker
	sidekiq_options retry: false

	def perform user_id, current_user_id
		user = User.find user_id
		current_user = User.find current_user_id
		NotificationMailer.notification(user, current_user).deliver if user.email
	end

end