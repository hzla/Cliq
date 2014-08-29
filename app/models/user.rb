class User < ActiveRecord::Base
	has_many :categories, through: :cat_interests
	has_many :activities, through: :interests
	has_many :events, through: :excursions, dependent: :destroy
	has_many :conversations, through: :connections
	has_many :cat_interests, dependent: :destroy 
	has_many :interests, dependent: :destroy 
	has_many :excursions, dependent: :destroy 
	has_many :connections, dependent: :destroy 
	has_many :authorizations, dependent: :destroy 
	has_many :messages, dependent: :destroy 

	validates :name, :presence => true
	attr_accessible :discuss_time, :toggle_count, :create_click_count, :event_view_count, :visit_count, :name, :email, :school, :bio, :profile_pic_url, :fb_token, :activation, :address, :sex, :sexual_preference, :latitude, :longitude, :active, :message_count, :invite_count, :updated_at, :event_count,:notify_messages, :notify_news, :notify_events, :timezone, :lbgtq, :blacklist, :characters

	geocoded_by :address
	after_validation :geocode    

	def saw_event
		self.invite_count -= 1	
		if self.invite_count < 0
			self.invite_count = 0
		end
		save
	end  

	def event_nots
		e = Event.messaged_joined_by self
		cs = e.map(&:conversation).compact
		cs.select {|n| !n.was_seen_by? self}.count
	end

	def self.create_with_facebook auth_hash
		timezone = auth_hash.extra.raw_info.timezone
		profile = auth_hash['info']
		fb_token = auth_hash.credentials.token
		gender =  auth_hash['extra']['raw_info']['gender']
		user = User.new name: profile['name'], profile_pic_url: profile['image'], fb_token: fb_token, sex: gender, email: profile['email'], timezone: timezone, address: "Orlando, Florida", school: "University of Central Florida"
    user.activation = user.generate_code
    user.authorizations.build :uid => auth_hash["uid"]
    user if user.save
	end

	def using
		Time.now - 15.minutes < updated_at 
	end

	def color
		sex == "male" ? "blue-card" : "pink-card"
	end

	def activate
		self.activation = 'activated'
		save
	end

	def activated?
		activation == 'activated' || activation == 'feedback'
	end

	def generate_code
		random = (48..122).map {|x| x.chr}
		characters = (random - random[43..48] - random[10..16])
		code = characters.map {|c| characters.sample}
		code.join
	end

	def user_time
		Time.now.utc + timezone.hours
	end
	
	#maps cat/act to users_ids, parse and count user_ids
	# if no activities are inputed return matches for all user activities
	# else do it just for the inputted activities
	# if a location is put in from autocomplete, find the location by id, if a location is put in 
	# but not from autocomplete, search by name, if not found, geocode it and add to database 
	# if no location, don't search by location
	def search_results location_id, location_name, act_ids, no_id
		results = no_id ? results_from_location(location_id, location_name) : results_from_location_and_acts(location_id, location_name, act_ids) 
	end

	def results_from_location_and_acts location_id, location_name, act_ids
		if location_id != "" && location_name != ""
			location = Location.find location_id
		elsif location_name != ""
			location = Location.retrieve_or_create_by_name location_name
		else
			location = nil
		end
		results = search_similar(Activity.parse_interests(act_ids), location)
	end

	def results_from_location location_id , location_name
		if location_id == "" && location_name == ""
			results = search_similar activities
		else
			if location_id != "" && location_name != ""
				location = Location.find location_id
			elsif location_name != ""
				location = Location.retrieve_or_create_by_name location_name
			else
				location = nil
			end
			results = search_similar activities, location
		end
	end

	def search_similar interest_type, location = nil #accepts a list of interests/categories
		return location if location == "invalid"
		
		interests = Interest.includes(:activity).where('activity_id in (?)', interest_type.map(&:id)).map do |interest|
				[interest.user_id, interest.activity]
		end.group_by {|int| int[0] }
		interests = interests.each do |k,v|
			interests[k] = interests[k].map {|act| act[1]}
		end #search interests for matching activites and group by users	

		if !location
			users = User.find interests.keys 
		else
			users = User.where('id in (?)', interests.keys).near(location, 50)
		end #map user_ids to users

		users = users.map {|user| [user, interests[user.id]]}
		
		clist = conversations.where(initiated: true).pluck(:name).map do |name|
			name.split("-")
		end.flatten.join(",")
		prelim_blacklist = "#{blacklist},#{clist}" 
		blist = "#{prelim_blacklist},#{id}".split(',').map(&:to_i)
		a = users.to_a.sort_by {|user| user[1].length}.reverse[0..99].select {|x| !blist.include?(x[0].id) }.shuffle[0..39].sort_by {|user| user[1].length}.reverse
		#sort results
	end

	def attendings
		excursions.where(attended: true).length 
	end

	def total_meetings
		total = events.map {|evt| evt.users.length}.inject(:+)
		total ? total : 0
	end

	# takes all of a users interests and divides them into major categories
	def formatted_interests
		results = {"Do" => [], "Watch" => [], "Music" => [], "Discuss" => []}
		formatted = {}
		acts = activities
		acts.each do |act|
			if formatted[act.category_id] 
				formatted[act.category_id] += [act]
			else
				formatted[act.category_id] = [act]
			end
		end
		formatted.each do |cat_id, acts|
			category = Category.find(cat_id)
			root = category.root
			if results[root.name]
				results[root.name] += [{category.full_name => acts}]
			else
				results[root.name] = [{category.full_name => acts}]
			end
		end
		results
	end

	#takes already formatted interests and puts them back together
	def unformatted_interests formatted
		formatted["Do"] + formatted["Watch"] + formatted["Music"] + formatted["Discuss"]
	end

	#all convesations with non blocked users where a message has been sent
	def ordered_conversations
		convos = conversations.where(initiated: true).order(:updated_at).reverse
		blacklist_ids = blacklist.split(",").map(&:to_i)[1..-1]
		convos = convos.select do |convo|
			user_ids = convo.users.map(&:id)
			user_ids.delete id
			other_id = user_ids[0]
			!blacklist_ids.include? other_id
		end
	end

	def blocked_by? user
		return false if !user 
		user.blacklist.split(",").include? id.to_s
	end

	def update_blacklist user_id
		current_list = blacklist
		current_list += ",#{user_id}"
		update_attributes blacklist: current_list
	end

	def conversated_with? user #do their conversations have at least one message from each person
        conversations.each do |convo|
			ids = convo.name.split("-").map(&:to_i)
			if convo.connected && ids.include?(id) && ids.include?(user.id) 
				return true
			end
		end
		false
	end

	#top two common categories with another user
	def top_shared user
		act_ids = interests.pluck(:activity_id)
		cats = user.activities.where('activity_id in (?)', act_ids).group_by(&:category_id).to_a.sort_by do |cat|
			cat[0]
		end
		top_two = cats[0..1].map do |cat|
			cat[0]
		end
		Category.find top_two
	end

	def talked_to? user #do they have any conversations at all?
		conversations.each do |convo|
			return convo if convo.users.include? user
		end
		false
	end

	def similarities_with user
		act_ids = interests.pluck(:activity_id)
		user.interests.where('activity_id in (?)', act_ids).length
	end

	def similar_categories_with user
		act_ids = cat_interests.pluck(:category_id)
		user.cat_interests.where('category_id in (?)', act_ids).pluck(:id).uniq.length
	end

	def similar_interests user, results
		result_ids = results.map(&:id)
		act_ids = activities.map(&:id)
		acts = user.interests.where('activity_id in (?)', act_ids).where('activity_id not in (?)', result_ids).map(&:activity)
		(results.shuffle + acts)
	end

	def first_name 
		name.split[0]
	end

	def prefers
		if sexual_preference == "homo"
			sex
		else
			if sex == "male"
				"female"
			else
				"male"
			end
		end
	end

	# task to add the catinterest for every interestyou've liked
	# and destroy any catinterest with no interests
	def self.add_cats
		all.each do |user|
			cat_ids = user.activities.pluck(:category_id).uniq
			cat_ids.each do |cat_id|
				CatInterest.find_or_create_by user_id: user.id, category_id: cat_id
			end
			user.cat_interests.where('category_id not in (?)', cat_ids).destroy_all
		end
	end

	def current_loc
		address ? address : school
	end

	# task to geocode all non seeded users
	def self.geocode_all
		users = User.where(latitude: nil).where('profile_pic_url is not null')
		failures = []
		users.each do |user|
			if user.address
				address = Geocoder.search(user.address)[0]
				if address != nil
					cords = address.coordinates
					user.update_attributes latitude: cords[0], longitude: cords[1]
				end
			elsif user.school
				address = Geocoder.search(user.school)[0]
				if address != nil
					cords = address.coordinates
					user.update_attributes latitude: cords[0], longitude: cords[1]
				end
			else
				failures << user
			end
		end
		p failures
	end

	def admin?
		role == "admin"
	end

	def obscured_pic
		lbgtq ? 'Rainbow.svg' : 'Cliq.svg'
	end

	def char_categories
		chars = characters.split(",")
		cat_list = []
		cat_list << "Eating Out"
		
		if sex == "male"
			if chars.include? "Athlete"
				cat_list += ["Outdoor Activities", "Visit Places", "Pop", "Electronic", "Comedic", "Action and Adventure", "Drama"]
			end
			if chars.include? "Partier"
				cat_list += ["Party", "Electronic", "Pop", "Rap and Hip Hop", "Rock", "Action and Adventure"]
			end
			if chars.include? "Intellectual"
				cat_list += ["Visit Places", "Board and Card", "Strategy and Puzzle", "Indie", "Academic", "Documentaries", "Misc"]
			end
			if chars.include? "Gamer"
				cat_list += ["Action, Adventure, and Fighting", "RPG", "Shooter", "Strategy and Puzzle", "Indie", "Rock", "Sci-Fi & Fantasy"]
			end
			if chars.include? "Creative"
				cat_list += ["Visit Places", "Board and Card", "Drama", "Musical", "Misc Topics", "Indie"]
			end
			if chars.include? "Maverick"
				cat_list += ["Visit Places", "Indie", "Documentaries", "Foreign", "Academic", "Misc Topics"]
			end
			if chars.include? "Shaman"
				cat_list += ["Party", "Electronic", "Indie", "Rock", "Comedic", "Sci-Fi & Fantasy"]
			end
			if chars.include? "Corporate Baller"
				cat_list += ["Visit Places", "News", "Action and Adventure", "Documentaries", "Dramatic", "Misc"]
			end
		else
			if chars.include? "Athlete"
				cat_list += ["Outdoor Activities", "Racing and Sports", "Shooter", "Electronic", "Rap and Hip Hop", "Action and Adventure"]
			end
			if chars.include? "Partier"
				cat_list += ["Outdoor Activities", "Visit Places", "Electronic", "Pop", "Action and Adventure", "Comedic", "Drama"]
			end
			if chars.include? "Intellectual"
				cat_list += ["Visit Places", "Board and Card", "Indie", "Foreign", "Documentaries", "Academic", "Misc"]
			end
			if chars.include? "Gamer"
				cat_list += ["Action, Adventure, and Fighting", "RPG", "Shooter", "Strategy and Puzzle", "Indie", "Rock", "Sci-Fi & Fantasy"]
			end
			if chars.include? "Creative"
				cat_list += ["Visit Places", "Indie", "Documentaries", "Foreign", "Romance", "Academic", "Misc Topics"]
			end
			if chars.include? "Maverick"
				cat_list += ["Visit Places", "Indie", "Documentaries", "Foreign", "Romance", "Academic", "Misc Topics", "Indie"]
			end
			if chars.include? "Shaman"
				cat_list += ["Party", "Electronic", "Indie", "Rock", "Comedic", "Sci-Fi & Fantasy", "Mobile"]
			end
			if chars.include? "Corporate Baller"
				cat_list += ["Visit Places", "News", "Action and Adventure", "Documentaries", "Dramatic", "Romance", "Misc"]
			end
		end
		cat_list = cat_list.uniq.map do |cat|
				Category.find_by_name cat
		end
		cat_list
	end
end




