class InterestSuggestion < ActiveRecord::Base
	attr_accessible :popularity, :term, :interest_id, :cat_type

	def self.interests_for prefix
		prefix = prefix.downcase
		ints = where("lower(term) like (?)", "%#{prefix}%").limit(10).order(:term).pluck(:term, :interest_id, :cat_type)
		parse_ints ints
	end

	def self.index_interests
		Activity.find_each do |int|
			create term: int.name, interest_id: "A-#{int.id}", cat_type: int.category.root.name
		end
		Category.find_each do |cat|
			create term: cat.name, interest_id: "C-#{cat.id}", cat_type: cat.root.name
		end
	end

	def self.index_term term, interest_id
    where(term: term, interest_id: interest_id).first_or_initialize.tap do |suggestion|
      suggestion.increment! :popularity
    end
  end

  def self.parse_ints ints
  	ints = ints.map do |int| 
  		{label: int[0], value: int[1], type: int[2]}
  	end
  	ints
  end
end