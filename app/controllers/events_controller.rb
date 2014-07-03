class EventsController < ApplicationController
	include SessionsHelper
	include ApplicationHelper
	skip_before_filter  :verify_authenticity_token

	def index
		excursions = current_user.excursions 
		invite_excursions = excursions.where(accepted: false).where(passed: false)
		@invitations = invite_excursions.where(created: false).map(&:event).compact.select { |event| event.start_time > Time.now }.sort_by(&:start_time)
		
		upcoming_excursions = excursions.where accepted: true
		@events = upcoming_excursions.map(&:event).compact.select { |event| event.start_time > Time.now }.sort_by(&:start_time)
		excursions.update_all seen: true
		current_user.update_attributes event_count: 0
	end

	def upcoming
		excursions = current_user.excursions.where(accepted: true)
		@events = excursions.map(&:event).compact.select { |event| event.start_time > Time.now }.sort_by(&:start_time)
		render partial: 'events', locals: {events: @events}
	end

	def past
		@events = current_user.excursions.where(accepted: true).map(&:event).select { |event| event.start_time < Time.now }.sort_by(&:start_time).reverse
		render partial: 'events', locals: {events: @events}
	end

	def going
		@events = current_user.excursions.where(accepted: true).map(&:event).select { |event| event.start_time > Time.now }.sort_by(&:start_time)
		render partial: 'events', locals: {events: @events}
	end

	def new
		@event = Event.new
		@user = User.find params[:user_id] 
		@partners = Partner.local_options
		render layout: false
	end

	def create
		event = Event.new params[:event]
		invited_user = User.find params[:user_id]
		if event.save
			invited_user.event_count += 1
			invited_user.save
			event.users << [invited_user, current_user]
			excursion = Excursion.where(event_id: event.id, user_id: current_user.id)[0]
			excursion.update_attributes created: true, accepted: true
			broadcast user_path(invited_user)+ "/events", event.to_json
			if event.image_url != nil
				redirect_to events_path and return
			else
				render json: {ok: true} and return
			end
		else
			render json: event.errors
		end
	end

	def show
		event = Event.find params[:id]
		render partial: 'invite_card', locals: {invite: event}
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