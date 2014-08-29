class ActivationMailerWorker
	include Sidekiq::Worker
	sidekiq_options retry: true

	def perform user_id, email
		user = User.find user_id
		UserMailer.welcome_email(user, email).deliver
	end
end