class Authorization < ActiveRecord::Base
	belongs_to :user
	validates :uid, :presence => true

	attr_accessible :uid
end