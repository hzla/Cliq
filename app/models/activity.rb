class Activity < ActiveRecord::Base
	has_many :users, through: :interests
	has_many :interests, dependent: :destroy 
	mount_uploader :activity_pic, ActivityPicUploader
	belongs_to :category

	attr_accessible :name, :category_id, :activity_pic, :remote_activity_pic_url, :suggested_by, :has_pic

	def shortened_name
		name.length > 25 ? name[0..24] + "..." : name  
	end

	def self.parse_interests ids
		activities = find ids.split(" ").select {|id| id[0] == "A" }.map {|id| id.split(/[^\d]/).join }
		categories = Category.find ids.split(" ").select {|id| id[0] == "C" }.map {|id| id.split(/[^\d]/).join }
		activities + categories
	end

	def self.suggestions
		acts = where 'suggested_by is not null'
		acts.each do |act|
			user = User.find(act.suggested_by).name
			category = act.category.name
			p "#{act.name} was suggested_by #{user} for the category #{category} on #{act.created_at.strftime("%m/%d/%g at %I:%M%p")}"  
		end
	end

	def shared_between? user, other_user
		users.include?(user) && users.include?(other_user)
	end
end