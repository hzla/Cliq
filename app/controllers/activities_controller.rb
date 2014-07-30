class ActivitiesController < ApplicationController

	def index
		render json: InterestSuggestion.interests_for(params[:term])
	end

	def choose
		category = Category.find params[:category_id]
		activities = category.activities
		acts = category.liked_not_liked_activities current_user
		liked = acts[0]
		not_liked = acts[1]
		act = Activity.new
		respond_to do |format|
  		format.html { render :layout => !request.xhr?, partial: 'choose', locals: {category: category, activities: activities, not_liked: not_liked, liked: liked, act: act} }
		end
	end

	def create
		Activity.create params[:activity]
		render nothing: true
	end

end