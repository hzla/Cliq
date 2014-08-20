class Location < ActiveRecord::Base
	geocoded_by :address
	after_validation :geocode  
	attr_accessible :name, :address, :latitude, :longitude

	def self.find_by_name name
  	where("name ILIKE ?", name).first
	end

	def self.retrieve_or_create_by_name name
		stored_location = where(name: name).first
		if stored_location
			return stored_location
		else
			cords = Geocoder.coordinates name
			if cords
				location = create name: name, latitude: cords[0], longitude: cords[1]
				LocationSuggestion.create term: name, location_id: location.id
			else
				location = "invalid"
			end
			return location
		end
	end
end
