class Message < ActiveRecord::Base
	belongs_to :conversation

	attr_accessible :body, :sender_id
end