class Message < ActiveRecord::Base
	belongs_to :conversation, touch: true;
	belongs_to :user
	validates :body, presence: true
	attr_accessible :body, :user_id, :conversation_id, :seen


	def date user
		tzone = Timezone::Zone.new(:latlon => [user.latitude, user.longitude])
		tzone.time(created_at).strftime("%m/%d %I:%M%p")
	end
end