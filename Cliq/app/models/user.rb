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

	validates :name, :presence => true
	attr_accessible :name, :email, :school, :bio, :profile_pic_url, :fb_token, :activation, :address, :sex, :sexual_preference, :latitude, :longitude 

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
	def search_similar interest_type 
		users = interest_type.map {|act_cat| [act_cat, act_cat.users.map(&:id).flatten]}
		similar_users = {}
		users.each do |entry|
			act = entry[0]
			user_ids = entry[1]
			user_ids.each do |id|
				similar_users[id] ? similar_users[id] << act : similar_users[id] = [act]
			end
		end
		similar_users
	end




end