class PagesController < ApplicationController
	def home
		session[:user_id]  = 177
	end
end