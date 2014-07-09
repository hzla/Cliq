class CategoriesController < ApplicationController
	include SessionsHelper
	

	def select
		@category = Category.find params[:id]
		@likes = current_user.interests.empty? ? 0 : @category.user_likes(current_user) 
		@categories = Category.main
	end

	def show
		category = Category.find params[:id]
		render partial: 'show', locals: {category: category}
	end
end