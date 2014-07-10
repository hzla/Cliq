class Category < ActiveRecord::Base
	has_many :activities
	has_many :users, through: :cat_interests
	has_many :cat_interests
	has_ancestry

	attr_accessible :name, :description, :parent_id, :parent, :question, :alt_text, :image, :image_url

	def user_likes user
		user.interests.map(&:activity).map(&:category).map(&:root).map(&:id).count id
	end

	def liked_not_liked_activities user
		ids = user.interests.map(&:activity_id)
		return [[], activities] if ids == []
		[activities.where('id in (?)', ids).order(:name), activities.where('id not in (?)', ids).order(:name)]
	end

	def ask
	 	if depth < 2
	 		question
	 	else
	 		inherited_question = parent.question.gsub parent.name.downcase, "#{name} #{parent.name.downcase}"
	 	end
	end

	def self.main
		where(ancestry: nil).order :name
	end

	def self.self_format
		[["Stuff you do for fun:", "Do"],["Music:", "Music"],["What you watch:", "Watch"], ["What you talk about:", "Discuss"]] 
	end

	def self.other_format name
		[["Stuff #{name} does for fun:", "Do"],["What he listens to:", "Music"],["What he watches:", "Watch"], ["What he likes to talk about:", "Discuss"]] 
	end

	def image_url
		url_name = name.split.map do |word|
			word[0].upcase + word[1..-1]
		end	
		url_name = url_name.join("_") + ".jpg"
		if parent.name == "TV Shows"
			url_name = "TV" + url_name
		end
		'https://s3.amazonaws.com/CliqBucket/Categories/' + url_name
	end


end