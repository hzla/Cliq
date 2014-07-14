class CategoriesController < ApplicationController
	include SessionsHelper
	

	def select
		@category = Category.find params[:id]
		@interests = current_user.interests.count
		@act = Activity.new
		@categories = Category.main
	end

	def show
		category = Category.find params[:id]
		act = Activity.new
		render partial: 'show', locals: {category: category, act: act}
	end
end