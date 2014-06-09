class Conversation < ActiveRecord::Base
	has_many :users, through: :connections
	has_many :connections
	has_many :messages

	attr_accessible :name


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
	end

end

