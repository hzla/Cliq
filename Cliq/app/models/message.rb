class Message < ActiveRecord::Base
	belongs_to :conversation, touch: true;
	belongs_to :user
	validates :body, presence: true
	attr_accessible :body, :user_id, :conversation_id, :seen


	def date
		(created_at - 7.hours).strftime("%m/%d %I:%M%p")
	end
end