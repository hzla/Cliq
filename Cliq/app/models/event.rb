class Event < ActiveRecord::Base
	belongs_to :partner
	has_many :users, through: :excursions
	has_many :excursions
	mount_uploader :image, ImageUploader

	attr_accessible :title, :description, :location, :start_time, :end_time, :image, :attended, :partner_id


	def creator
		excursions.where(created: true)[0].user
	end

	def time
		if start_time - Time.now < 24.hours
			created_at.strftime "Today at %I:%M%p"
		else
			created_at.strftime("%m/%d/%g at %I:%M%p") 
		end
	end

	def attendees
		excursions.where(accepted: true)
	end
end