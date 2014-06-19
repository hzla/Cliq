class LocationSuggestion < ActiveRecord::Base
	attr_accessible :popularity, :term, :location_id

	def self.locations_for prefix
		prefix = prefix.split(" ").map(&:capitalize).join(" ")
		locs = where("term like (?)", "#{prefix}_%").limit(10).pluck(:term, :location_id)
		parse_locs locs
	end

	def self.index_locations
		Location.find_each do |loc|
			LocationSuggestion.create term: loc.name, location_id: loc.id
		end
	end

	def self.index_term term, location_id
    where(term: term, location_id: location_id).first_or_initialize.tap do |suggestion|
      suggestion.increment! :popularity
    end
  end

  def self.parse_locs locs
  	locs = locs.map do |loc| 
  		{label: loc[0], value: loc[1]}
  	end
  	locs
  end


end
