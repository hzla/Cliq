class EventsController < ApplicationController
	include SessionsHelper

	def index
		@invitations = current_user.excursions.where(accepted: false).where(passed: false).map(&:event).sort_by(&:start_time)
		@events = Event.all.order(:start_time)
	end


	def new
		@event = Event.new
		@user = User.find params[:user_id] 
		@partners = Partner.local_options
	end

	def create
		event = Event.new params[:event]
		invited_user = User.find params[:user_id]
		event.users << [invited_user, current_user] if event.save
		excursion = Excursion.where(event_id: params[:id], user_id: current_user.id)[0]
		excursion.update_attributes created: true
		redirect_to search_path
	end

	def accept
		excursion = Excursion.where(event_id: params[:id], user_id: current_user.id)[0]
		excursion.update_attributes accepted: true
		render :nothing => true, :status => 200, :content_type => 'text/html'
	end

	def pass
		excursion = Excursion.where(event_id: params[:id], user_id: current_user.id)[0]
		excursion.update_attributes passed: true
		render :nothing => true, :status => 200, :content_type => 'text/html'
	end




end