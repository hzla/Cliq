class Category < ActiveRecord::Base
	has_many :activities
	has_many :users, through: :cat_interests
	has_many :cat_interests
	has_ancestry

	attr_accessible :name, :description, :parent_id
end