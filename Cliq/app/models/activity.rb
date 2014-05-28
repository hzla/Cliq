class Activity < ActiveRecord::Base
	has_many :users, through: :interests
	has_many :interests

	belongs_to :category

	attr_accessible :name, :cateogory
end