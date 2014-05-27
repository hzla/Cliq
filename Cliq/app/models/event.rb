class Event < ActiveRecord::Base
	belongs_to :partner
	has_many :users, through: :excursions
	has_many :excursions

	attr_accessible :title, :description, :location, :start_time, :end_time
end