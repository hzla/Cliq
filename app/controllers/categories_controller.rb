class CategoriesController < ApplicationController
	include SessionsHelper
	

	def index
		@category = Category.where(name: "Do").first
		@likes = @category.user_likes current_user
	end

	def show
		category = Category.find params[:id]
		render partial: 'show', locals: {category: category}
	end

	

end