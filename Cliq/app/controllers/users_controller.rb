class UsersController < ApplicationController
	before_filter :get_user

	def show
		respond_to do |format|
  		format.html 
  		format.json { render :json => @user }
		end
	end

	def activate
		if params[:code] == @user.activation
			session[:user_id] = @user.id
			@user.activate
			@message = "You have been activated"
		else
			@message = "Activation Failed"
		end
	end

	def search
		@results = current_user.search_similar(current_user.activities)[1..-1]
	end

	def search_results
		location = Location.find params[:location_id]
		results = current_user.search_similar(Activity.parse_interests params[:ids], location )
		p results

		render partial: "search_results", locals {results: results}
	end

private
	
	def get_user
		@user = params[:user_id] ? User.find(params[:user_id]) : User.find(params[:id]) if params[:id]
	end

end