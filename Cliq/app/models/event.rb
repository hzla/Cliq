class Event < ActiveRecord::Base
	belongs_to :partner
	has_many :users, through: :excursions
	has_many :excursions
	mount_uploader :image, ImageUploader

	attr_accessible :title, :description, :location, :start_time, :end_time, :image, :attended


	def creator
		excursions.where(created: true)[0].user
	end
end