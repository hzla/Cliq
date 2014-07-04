class User < ActiveRecord::Base
	has_many :categories, through: :cat_interests
	has_many :activities, through: :interests
	has_many :events, through: :excursions
	has_many :conversations, through: :connections
	has_many :cat_interests
	has_many :interests 
	has_many :excursions
	has_many :connections
	has_many :authorizations
	has_many :messages

	validates :name, :presence => true
	attr_accessible :name, :email, :school, :bio, :profile_pic_url, :fb_token, :activation, :address, :sex, :sexual_preference, :latitude, :longitude, :active, :message_count, :invite_count, :event_count 

	geocoded_by :address
	after_validation :geocode      

	def self.create_with_facebook auth_hash
		profile = auth_hash['info']
		fb_token = auth_hash.credentials.token
		user = User.new name: profile['name'], profile_pic_url: profile['image'], fb_token: fb_token
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

	def category_activities parent
		categories = parent.descendants
		categories.map do |cat|
			acts = cat.activities.select {|act| act.users.include? self }
			if acts	== []		
				nil
			else
				[cat, acts]
			end
		end
	end

	def formatted_cat_acts 
		formatted = []
		formatted[0] = category_activities(Category.where(name: "Do").first).compact
		formatted[1] = category_activities(Category.where(name: "Watch").first).compact
		formatted[2] = category_activities(Category.where(name: "Music").first).compact
		formatted[3] = category_activities(Category.where(name: "Discuss").first).compact
		formatted
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
				results[root.name] += [{category.name => acts}]
			else
				results[root.name] = [{category.name => acts}]
			end
		end
		results
	end

	def ordered_conversations
		conversations.where(connected: true).order(:updated_at).reverse
	end


	def conversated_with? user
		conversations.each do |convo|
			ids = convo.messages.map(&:user_id)
			if convo.users.include?(user) && ids.include?(id) && ids.include?(user.id) 
				return true
			end
		end
		false
	end

	def similarities_with user
		act_ids = activities.map(&:id)
		user.interests.where('activity_id in (?)', act_ids).length
	end

	def first_name 
		name.split[0]
	end


end