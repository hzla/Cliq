class Conversation < ActiveRecord::Base
	has_many :users, through: :connections
	has_many :connections

	attr_accessible :name
end

