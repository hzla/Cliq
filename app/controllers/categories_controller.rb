class CategoriesController < ApplicationController
	include SessionsHelper
	

	def select
		@category = Category.find params[:id]
		if current_user.interests.empty?
			@likes = 0
		else
			@likes = @category.user_likes current_user 
		end
		@categories = Category.where(ancestry: nil).order :name
	end

	def show
		category = Category.find params[:id]
		render partial: 'show', locals: {category: category}
	end
end