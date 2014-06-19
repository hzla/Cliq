class Activity < ActiveRecord::Base
	has_many :users, through: :interests
	has_many :interests

	belongs_to :category

	attr_accessible :name, :category_id

	def shortened_name
		name.length > 25 ? name[0..24] + "..." : name  
	end

	def parse_interests ids
		activities = find ids.select {|id| id[0] == "A" }.map {|id| id.split(/[^\d]/).join }
		categories = Category.find ids.select {|id| id[0] == "C" }.map {|id| id.split(/[^\d]/).join }
		activities + categories
	end
end