class LocationsController < ApplicationController
	
	def index
		render json: LocationSuggestion.locations_for(params[:term])
	end
end