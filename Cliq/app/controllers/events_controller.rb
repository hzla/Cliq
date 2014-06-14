class EventsController < ApplicationController
	include SessionsHelper

	def index
		@invitations = current_user.excursions.where(accepted: false).where(passed: false).map(&:event)
		@events = Event.all.order(:start_time)
	end


	def new
		@event = Event.new
		@user = User.find params[:user_id] 
	end

	def create
		event = Event.new params[:event]
		invited_user = User.find params[:user_id]
		event.users << [invited_user, current_user] if event.save
		redirect_to search_path
	end




end