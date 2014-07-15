class Partner < ActiveRecord::Base
	has_many :events, dependent: :destroy 

	attr_accessible :name, :description, :location, :start_time, :end_time, :location, :mon, :tues, :wed, :thurs, :fri, :sat, :sun, :id

	def self.local_options
		self.all.map do |partner|
			[partner.name, partner.id, {id: partner.id}]
		end
	end
end