class Interest < ActiveRecord::Base
	belongs_to :user
	belongs_to :activity

	attr_accessible :user_id, :activity_id
end