class User < ActiveRecord::Base
	has_many :activities, through: :interests
	has_many :events, through: :excursions
	has_many :conversations, through: :connections
	has_many :interests 
	has_many :excursions
	has_many :connections

	attr_accessible :first_name, :last_name, :email, :school, :bio
end