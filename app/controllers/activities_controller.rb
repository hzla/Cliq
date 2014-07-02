class ActivitiesController < ApplicationController

	def index
		render json: InterestSuggestion.interests_for(params[:term])
	end

	def choose
		category = Category.find params[:category_id]
		activities = category.activities
		acts = category.liked_activities current_user
		not_liked = acts[0]
		liked = acts[1]
		render partial: 'choose', locals: {category: category, activities: activities, not_liked: not_liked, liked: liked}
	end
end