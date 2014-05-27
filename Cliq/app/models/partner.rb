class Partner < ActiveRecord::Base
	has_many :events

	attr_accessible :title, :description, :location, :start_time, :end_time
end