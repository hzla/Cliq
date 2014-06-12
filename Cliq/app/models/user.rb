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
	def search_similar interest_type #accepts a list of interests/categories
		users = interest_type.map {|act_cat| [act_cat, act_cat.users.flatten]}
		similar_users = {}
		users.each do |entry|
			act_cat = entry[0]
			users = entry[1]
			users.each do |user|
				similar_users[user] ? similar_users[user] << act_cat : similar_users[user] = [act_cat]
			end
		end
		similar_users.to_a.sort_by {|user| user[1].length}.reverse
	end

	def attendings
		excursions.where(attended: true).length 
	end

	def total_meetings
		total = events.map {|evt| evt.users.length}.inject(:+)
		total ? total : 0
	end

	def category_activities
		categories.map do |cat|
			acts = cat.activities.select {|act| act.users.include? self }
			[cat, acts] 
		end
	end

	def ordered_conversations
		conversations.order(:updated_at).reverse
	end



end