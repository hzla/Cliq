class ActivitiesController < ApplicationController

	def index
		render json: InterestSuggestion.interests_for(params[:term])
	end
end