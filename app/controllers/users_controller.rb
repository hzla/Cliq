class UsersController < ApplicationController
	before_filter :get_user

	def show
		respond_to do |format|
  		format.html 
  		format.json { render :json => @user }
		end

	end

	def activate
		session[:user_id] = params[:id]
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
		if params[:location_id] != ""
			location = Location.find params[:location_id]
		else
			location = nil
		end
		results = current_user.search_similar Activity.parse_interests(params[:ids]), location
		render partial: "search_results", locals: {results: results}
	end

private
	
	def get_user
		@user = params[:user_id] ? User.find(params[:user_id]) : User.find(params[:id]) if params[:id]
	end

end