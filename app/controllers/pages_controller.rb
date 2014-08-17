class PagesController < ApplicationController

	skip_before_action :require_login

	def home
		if current_user
			redirect_to events_path
		end
	end

	def faq
	end

	def help
	end

	def about
	end

	def contact
	end

	def privacy
	end

	def terms
	end

	def about
	end
end