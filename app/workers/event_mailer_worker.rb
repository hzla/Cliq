class EventMailerWorker
	include Sidekiq::Worker
	sidekiq_options retry: false

	def perform invited_user_id, event_id
		invited_user = User.find invited_user_id
		event = Event.find event_id
		NotificationMailer.event_notification(invited_user, event).deliver if invited_user.email
	end

end