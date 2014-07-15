class User < ActiveRecord::Base
	has_many :categories, through: :cat_interests
	has_many :activities, through: :interests
	has_many :events, through: :excursions
	has_many :conversations, through: :connections
	has_many :cat_interests, dependent: :destroy 
	has_many :interests, dependent: :destroy 
	has_many :excursions, dependent: :destroy 
	has_many :connections, dependent: :destroy 
	has_many :authorizations, dependent: :destroy 
	has_many :messages, dependent: :destroy 

	validates :name, :presence => true
	attr_accessible :name, :email, :school, :bio, :profile_pic_url, :fb_token, :activation, :address, :sex, :sexual_preference, :latitude, :longitude, :active, :message_count, :invite_count, :event_count,:notify_messages, :notify_news, :notify_events, :timezone  

	geocoded_by :address
	after_validation :geocode      

	def self.create_with_facebook auth_hash
		timezone = auth_hash.extra.raw_info.timezone
		profile = auth_hash['info']
		fb_token = auth_hash.credentials.token
		gender =  auth_hash['extra']['raw_info']['gender']
		user = User.new name: profile['name'], profile_pic_url: profile['image'], fb_token: fb_token, sex: gender, email: profile['email'], timezone: timezone
    user.activation = user.generate_code
    user.authorizations.build :uid => auth_hash["uid"]
    user if user.save
	end

	def activate
		self.activation = 'activated'
		save
	end

	def activated?
		activation == 'activated'
	end

	def generate_code
		random = (48..122).map {|x| x.chr}
		characters = (random - random[43..48] - random[10..16])
		code = characters.map {|c| characters.sample}
		code.join
	end
	
	#maps cat/act to users_ids, parse and count user_ids
	def search_similar interest_type, location = nil #accepts a list of interests/categories
		return location if location == "invalid"
		if !location
			users = interest_type.map {|act_cat| [act_cat, act_cat.users.flatten]}
		else
			users = interest_type.map {|act_cat| [act_cat, act_cat.users.near(location, 50)]}
			users = users.select {|entry| !entry[1].empty?}
		end
		similar_users = {}
		users.each do |entry|
			act_cat = entry[0]
			users = entry[1]
			users.each do |user|
				similar_users[user] ? similar_users[user] << act_cat : similar_users[user] = [act_cat]
			end
		end
		similar_users.to_a.sort_by {|user| user[1].length}.reverse[0..14].select {|x| x[0].id != id }
	end

	def attendings
		excursions.where(attended: true).length 
	end

	def total_meetings
		total = events.map {|evt| evt.users.length}.inject(:+)
		total ? total : 0
	end

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

	def ordered_conversations
		conversations.where(connected: true).order(:updated_at).reverse
	end

	def conversated_with? user #do their conversations have at least one message form each person?
		conversations.each do |convo|
			ids = convo.messages.map(&:user_id)
			if convo.users.include?(user) && ids.include?(id) && ids.include?(user.id) 
				return true
			end
		end
		false
	end

	def talked_to? user #do they any conversations at all?
		conversations.each do |convo|
			return convo if convo.users.include? user
		end
		false
	end

	def similarities_with user
		act_ids = activities.map(&:id)
		user.interests.where('activity_id in (?)', act_ids).length
	end

	def similar_interests user, results
		result_ids = results.map(&:id)
		act_ids = activities.map(&:id)
		acts = user.interests.where('activity_id in (?)', act_ids).where('activity_id not in (?)', result_ids).map(&:activity)
		(results.shuffle[0..5] + acts)[0..5]
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

	def current_loc
		address ? address : school
	end

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
end