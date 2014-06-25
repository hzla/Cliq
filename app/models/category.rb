class Category < ActiveRecord::Base
	has_many :activities
	has_many :users, through: :cat_interests
	has_many :cat_interests
	has_ancestry

	attr_accessible :name, :description, :parent_id, :parent, :question, :alt_text

	def user_likes user
		user.interests.map(&:activity).map(&:category).map(&:root).map(&:id).count id
	end

	def liked_activities user
		ids = user.interests.map(&:activity_id)
		[activities.where('id not in (?)', ids), activities.where('id in (?)', ids)]
	end

end