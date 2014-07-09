class Connection < ActiveRecord::Base
	belongs_to :user
	belongs_to :conversation

	attr_accessible :connected, :emailed
end