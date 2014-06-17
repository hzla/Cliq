class PagesController < ApplicationController

	skip_before_action :require_login

	def home
		session[:user_id] = 1000
	end
end