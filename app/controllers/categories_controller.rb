class CategoriesController < ApplicationController
	include SessionsHelper
	

	def select
		@category = Category.find params[:id]
		@interests = current_user.interests.count
		@act = Activity.new
		@categories = Category.main

		@activities = @category.activities
		acts = @category.liked_not_liked_activities current_user
		@liked = acts[0]
		@not_liked = acts[1]
	end

	def show
		category = Category.find params[:id]
		act = Activity.new

		activities = category.activities
		acts = category.liked_not_liked_activities current_user
		liked = acts[0]
		not_liked = acts[1]
		render partial: 'show', locals: {category: category, act: act, activities: activities, liked: liked, not_liked: not_liked}
	end

	def tutorial
		@characters = ["Athlete", "Corporate_Baller", "Intellectual", "Partier", "Maverick", "Shaman", "Gamer", "Creative"]
		
	end

	def tutorial_select
		current_user.update_attributes school: params[:school], characters: params[:characters]
		@act_list = current_user.interests.pluck(:activity_id)
		@categories = current_user.char_categories
		@act = Activity.new
		@category = @categories[1]
		p @categories
		p @category
		puts "\n" * 40
	end
end