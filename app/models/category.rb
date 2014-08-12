class Category < ActiveRecord::Base
	has_many :activities
	has_many :users, through: :cat_interests
	has_many :cat_interests
	has_ancestry

	attr_accessible :name, :description, :parent_id, :parent, :question, :alt_text, :image, :image_url, :popularity, :ancestry

	def user_likes user
		user.interests.map(&:activity).map(&:category).map(&:root).map(&:id).count id
	end

	def liked_not_liked_activities user
		ids = user.interests.map(&:activity_id)
		return [[], activities] if ids == []
		[activities.where('id in (?)', ids).where(suggested_by: nil).order('LOWER(name)'), activities.where('id not in (?)', ids).where(suggested_by: nil).order('LOWER(name)')]
	end

	def ask
	 	if parent && parent.name == "Music"
	 		inherited_question = parent.question.gsub parent.name.downcase, "#{name} #{parent.name.downcase}"
	 	elsif depth < 2 
	 		question
	 	else
	 		inherited_question = parent.question.gsub parent.name.downcase, "#{name} #{parent.name.downcase}"
	 	end
	end

	def self.main
		where(ancestry: nil).order :name
	end

	def self.self_format
		cats = Category.where(ancestry: nil).order(:name)
		[["Stuff you do for fun:", "Do", cats[1].id],["Music:", "Music", cats[2].id],["What you watch:", "Watch", cats[3].id], ["What you talk about:", "Discuss", cats[0].id]] 
	end

	def self.other_format name, sex
		pronoun = sex == "male" ? "he" : "she"
		[["Stuff #{name} does for fun:", "Do"],["What #{pronoun} listens to:", "Music"],["What #{pronoun} watches:", "Watch"], ["What #{pronoun} likes to talk about:", "Discuss"]] 
	end

	def image_url
		url_name = name.split.map do |word|
			word[0].upcase + word[1..-1]
		end	
		url_name = url_name.join("_") + ".jpg"
		if parent && parent.name == "TV Shows"
			url_name = "TV" + url_name
		end
		'https://s3.amazonaws.com/CliqBucket/Categories/' + url_name
	end

	def thumb_image_url
		image_url.gsub(".jpg", "_Thumbnail.jpg")
	end

	def full_name
		if depth > 1
			name + " " + parent.name
		else
			name
		end
	end

	def selected user
		!user.cat_interests.where(category_id: id).empty?
	end

	def short_name
		short = name[0..19]
		short += "..." if short.length == 20
		short
	end

	def mobile_name 
		split_name = name.split(" ")
		mobile = []
		split_name.each do |word|
			if !mobile.last
				mobile << word
			elsif mobile[-1].length > 5
				mobile << word
			else
				mobile[-1] += " #{word}"
			end
		end
		mobile
	end

	def self.update_top
		where('ancestry is not null').each do |cat|
			pop = cat.activities.map(&:interests).count
			cat.update_attributes popularity: pop
			p cat.name
		end
	end

	def self.top cats, limit
		cats.order(:popularity).reverse[0..limit]
	end

	def self.partitioned_top limit
		cats = where(ancestry: nil).map do |cat|
			top cat.children, limit
		end
		cats.flatten
	end


end