class Conversation < ActiveRecord::Base
	has_many :users, through: :connections
	has_many :connections, dependent: :destroy 
	has_many :messages, dependent: :destroy 

	attr_accessible :name, :connected

	def ordered_messages
		messages.order('created_at DESC').limit(20).reverse 
	end


	def get_other_user user
		users.where('user_id not in (?)', [user.id])[0]
	end

	def date user
		time = messages.order(:created_at).pluck(:created_at).last
		return "no message yet" if !time
		# tzone = Timezone::Zone.new(:latlon => [user.latitude, user.longitude])
     if (Time.now - 1.day) < time
			(time - 4.hours).strftime("%I:%M %p")
		else
			(time - 4.hours).strftime("%m/%d/%g")
		end
	end

	def last_message 
		return "no message yet" if messages.empty?
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
		Connection.where(user_id: user.id, conversation_id: id).first.update_attributes(emailed: false)
	end

end

