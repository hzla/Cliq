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
	end

private
	
	def get_user
		@user = params[:user_id] ? User.find(params[:user_id]) : User.find(params[:id]) if params[:id]
	end

end