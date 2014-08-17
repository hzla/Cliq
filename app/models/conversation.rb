class Conversation < ActiveRecord::Base
	has_many :users, through: :connections
	has_many :connections, dependent: :destroy 
	has_many :messages, dependent: :destroy 
	belongs_to :event


	attr_accessible :name, :connected, :initiated, :event_id, :seen_by

	def ordered_messages
		messages.order('created_at DESC').limit(20).reverse 
	end

	def was_seen_by user
		self.seen_by = "" if seen_by == nil
		if !self.seen_by.split(",").include?(user.id.to_s) 
			self.seen_by += "#{user.id}," 
			self.save
			return true
		else
			return false
		end
	end

	def was_seen_by? user
		return false if !seen_by
		seen_by.split(",").include? user.id.to_s
	end

	def clear_seen_by user
		update_attributes seen_by: "#{user.id},"
	end

	def email_all_others user
		list = event.attendees.map(&:user).select { |u| u.id != user.id }
		list.each do |u|
			u.invite_count += 1
			if was_seen_by?(u) && !u.using
				EventMailerWorker.perform_async u.id, event.id
				u.save
			end
		end
	end

	def get_other_user user
		return nil if event_id
		users.where('user_id not in (?)', [user.id])[0]
	end

	def date user
		time = messages.order(:created_at).pluck(:created_at).last
		return "no message yet" if !time
		# tzone = Timezone::Zone.new(:latlon => [user.latitude, user.longitude])
     if (Time.now - 1.day) < time
			(time + user.timezone.hours).strftime("%I:%M %p")
		else
			(time + user.timezone.hours).strftime("%m/%d/%g")
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
		if other_user
            unseen = messages.where seen: false, user_id: other_user.id
            new_count = user.message_count - unseen.length
            user.update_attributes message_count: new_count
            unseen.update_all seen: true	
            Connection.where(user_id: user.id, conversation_id: id).first.update_attributes(emailed: false)
        end
    end

end

