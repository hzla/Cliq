class Excursion < ActiveRecord::Base
	belongs_to :user
	belongs_to :event

	attr_accessible :created, :passed, :accepted
end