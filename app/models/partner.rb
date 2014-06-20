class Partner < ActiveRecord::Base
	has_many :events

	attr_accessible :name, :description, :location, :start_time, :end_time, :location, :mon, :tues, :wed, :thurs, :fri, :sat, :sun

	def self.local_options
		self.all.map do |partner|
			[partner.name, partner.id, {id: partner.id}]
		end
	end
end