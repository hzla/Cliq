class Message < ActiveRecord::Base
	belongs_to :conversation
	belongs_to :user

	attr_accessible :body, :user_id, :conversation_id


	def date
		(created_at - 7.hours).strftime("%m/%d %I:%M%p")
	end
end