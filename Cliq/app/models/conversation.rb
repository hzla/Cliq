class Conversation < ActiveRecord::Base
	has_many :users, through: :connections
	has_many :connections
	has_many :messages

	attr_accessible :name

	def ordered_messages
		messages.order :created_at
	end


	def get_other_user user
		users.where('user_id not in (?)', [user.id])[0]
	end

	def date
		time = messages.order(:created_at).pluck(:created_at).last
		if (Time.now - 1.day) < time
			time = time - 7.hours
			time.strftime("%I:%M%p")
		else
			time - 6.hours
		end
	end

	def last_message 
		message = messages.order(:created_at).pluck(:body).last[0..29]
		message += "..." if message.length == 30
		message
	end

	def update_notifications user
		other_user = get_other_user user
		unseen = messages.where seen: false, user_id: other_user.id
		new_count = user.message_count - unseen.length
		user.update_attributes message_count: new_count
		unseen.update_all seen: true		
	end

end

