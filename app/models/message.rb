class Message < ActiveRecord::Base
	belongs_to :conversation, touch: true
	belongs_to :user
	validates :body, presence: true
	attr_accessible :body, :user_id, :conversation_id, :seen


	def date user
		(created_at + user.timezone.hours).strftime("%B %d")
	end

	def html_body
		text = body.gsub(/(<.*>).*(<.*>)/, "")
		text = text.gsub(/(<.*>)/, "")
		other_text = text.gsub(/\[link\]\((.*)\)/, "")
		match = Regexp.last_match(1)
		if match
			if match[0..6] != 'http://'
				url_match = 'http://' + match
			else
				url_match = match
			end
			text.gsub(/\[link\]\((.*)\)/, "<a href='#{url_match}'>#{match}</a>")
		else
			text
		end
	end
end