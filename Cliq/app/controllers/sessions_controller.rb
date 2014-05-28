class SessionsController < ApplicationController
	include SessionsHelper

	def create
	  redirect_to user_path current_user and return if current_user
	  auth_hash = request.env['omniauth.auth']
	  auth = Authorization.find_by_uid auth_hash['uid']
	  #redirect to user page if they've already authorized
	  if auth
	    session[:user_id] = auth.user.id
	    redirect_to user_path auth.user and return
	  else #create new user if not authorized
	    user = User.create_with_facebook auth_hash
	    session[:user_id] = user.id 
	    redirect_to user_path user 
	  end
	end

	def failure
	end

	def destroy
		session[:user_id] = nil
		redirect_to root_path
	end
end