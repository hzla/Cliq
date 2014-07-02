class Location < ActiveRecord::Base
	geocoded_by :address
	after_validation :geocode  
	attr_accessible :name, :address, :latitude, :longitude

	def self.find_by_name name
  	where("name ILIKE ?", name).first
	end

end
