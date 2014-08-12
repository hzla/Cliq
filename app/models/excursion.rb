class Excursion < ActiveRecord::Base
	belongs_to :user
	belongs_to :event

	attr_accessible :created, :passed, :accepted, :seen, :event_id, :user_id
end