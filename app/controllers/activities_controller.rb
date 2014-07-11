class ActivitiesController < ApplicationController

	def index
		render json: InterestSuggestion.interests_for(params[:term])
	end

	def choose
		category = Category.find params[:category_id]
		activities = category.activities
		acts = category.liked_not_liked_activities current_user
		p acts
		liked = acts[0]
		not_liked = acts[1]
		act = Activity.new
		render partial: 'choose', locals: {category: category, activities: activities, not_liked: not_liked, liked: liked, act: act}
	end

	def create
		Activity.create params[:activity]
		render nothing: true
	end

end