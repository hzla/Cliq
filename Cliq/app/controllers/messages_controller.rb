class MessagesController < ApplicationController
	include SessionsHelper

	before_filter :get_user

	def index
	end

	private

	def get_user
		@user = current_user if current_user
	end
end