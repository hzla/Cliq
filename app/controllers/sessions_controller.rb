class SessionsController < ApplicationController
	include SessionsHelper
	skip_before_action :require_login


	def create
	  redirect_to games_path and return if current_user
	  auth_hash = request.env['omniauth.auth']
	  auth = Authorization.find_by_uid auth_hash['uid']
	  #redirect to user page if they've already authorized
	  if auth
	    session[:user_id] = auth.user.id
	    current_user.update_attributes active: true
	    redirect_to games_path(sign_in: true) and return
	  else #create new user if not authorized
	    user = User.create_with_facebook auth_hash
	    session[:user_id] = user.id 
	    current_user.update_attributes active: true
	    if browser.mobile?
	    	redirect_to events_path and return
	    end
	    redirect_to events_path({welcome: true})
	  end
	end

	def failure
	end

	def destroy
		current_user.update_attributes active: false;
		session[:user_id] = nil
		redirect_to root_path
	end
end