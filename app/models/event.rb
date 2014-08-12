class Event < ActiveRecord::Base
	belongs_to :partner
	has_many :users, through: :excursions
	has_many :excursions, dependent: :destroy 
	mount_uploader :image, ImageUploader

	validates :title, presence: true
	validates :location, presence: true
	validates :start_time, presence: true

	attr_accessible :title, :description, :location, :start_time, :end_time, :image, :attended, :partner_id, :quantity, :remote_image_url, :closed


	def creator
		excursions.where(created: true)[0].user
	end

	def time user
		# if start_time - Time.now < 24.hours
		# 	tzone.time(start_time).strftime("%m/%d/%g at %I:%M%p")
		# else
		# 	tzone.time(start_time).strftime("%m/%d/%g at %I:%M%p") 
		# end
		if start_time - Time.now < 24.hours
			(start_time).strftime("%m/%d/%g at %I:%M%p")
		else
			(start_time).strftime("%m/%d/%g at %I:%M%p") 
		end
	end

	def attendees
		excursions.where(accepted: true)
	end

	def accepted?
		excursions.where(accepted: false).empty?
	end

	def untouched_by? user
		Excursion.where(user_id: user.id, event_id: id).empty?
	end

	def people_count
		excursions.where(accepted: true).count
	end


end