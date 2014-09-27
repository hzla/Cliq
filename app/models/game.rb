class Game < ActiveRecord::Base
	belongs_to :user
	attr_accessible :user_id, :numbers, :name, :creator_id, :winner_id, :loser_id, :points, :won

end