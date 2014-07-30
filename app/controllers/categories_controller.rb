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
end