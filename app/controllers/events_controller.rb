class EventsController < ApplicationController
	include SessionsHelper
	include ApplicationHelper
	skip_before_filter  :verify_authenticity_token

	def index
		excursions = current_user.excursions 
		invite_excursions = excursions.where(created: true)
		@invitations = invite_excursions.map(&:event).compact.select { |event| event.start_time > (Time.now - 6.hours) && event.closed == "public" }.sort_by(&:start_time)
		@open = true
		@events = Event.where(closed: "public").select { |event| event.start_time > (Time.now - 6.hours) && event.untouched_by?(current_user) }.sort_by(&:start_time)
		
		excursions.update_all seen: true
		current_user.update_attributes event_count: 0
		respond_to do |format|
        format.html { render :layout => !request.xhr? }
        # other formats
    end
	end

	def upcoming
		excursions = current_user.excursions.where(accepted: true)
		@events = excursions.map(&:event).compact.select { |event| event.start_time > (Time.now - 6.hours) }.select {|event| event.accepted? }.sort_by(&:start_time)
		render partial: 'events', locals: {events: @events}
	end

	def past
		@events = current_user.excursions.where(accepted: true).map(&:event).select { |event| event.start_time < (Time.now - 6.hours) }.sort_by(&:start_time).reverse
		render partial: 'events', locals: {events: @events}
	end

	def going
		@events = current_user.excursions.where(accepted: true).map(&:event).select { |event| event.start_time > (Time.now - 6.hours) }.sort_by(&:start_time)
		@open = false
		render partial: 'events', locals: {events: @events, open: @open}
	end

	def open
		@events = Event.where(closed: "public").select { |event| event.start_time > (Time.now - 6.hours) && event.untouched_by?(current_user) }.sort_by(&:start_time)
		@open = true
		render partial: 'events', locals: {events: @events, open: @open}
	
	end

	def new
		@event = Event.new
		@user = User.find params[:user_id] 
		@partners = Partner.local_options.sort_by {|n| n[0]}
		render layout: false
	end

	def public_new
		@event = Event.new
		@user = current_user
		@partners = Partner.local_options.sort_by {|n| n[0]}
		render layout: false
	end

	def public_create
		p params[:event]
		puts "\n" * 40
		event = Event.new params[:event]
		if event.save
			event.users << [current_user]
			excursion = Excursion.where(event_id: event.id, user_id: current_user.id)[0]
			excursion.update_attributes created: true, accepted: true
			redirect_to events_path
		else
			render json: event.errors
		end
	end

	def create
		p params[:event]
		puts "\n" * 30
		event = Event.new params[:event]
		invited_user = User.find params[:user_id]
		if event.save
			if !current_user.blocked_by?(invited_user)
				invited_user.event_count += 1
				invited_user.save
				event.users << [invited_user, current_user]
				excursion = Excursion.where(event_id: event.id, user_id: current_user.id)[0]
				excursion.update_attributes created: true, accepted: true
				broadcast user_path(invited_user)+ "/events", event.to_json
				if invited_user.notify_events && (!invited_user.active || !invited_user.using)
					EventMailerWorker.perform_async invited_user.id, current_user.id, event.id
					#NotificationMailer.event_notification(invited_user, current_user, event).deliver if invited_user.email
				end
				if event.image_url != nil
					redirect_to(:back) and return
				else
					render json: {ok: true} and return
				end
			else
				event.users << [current_user]
				excursion = Excursion.where(event_id: event.id, user_id: current_user.id)[0]
				excursion.update_attributes created: true, accepted: true
				if event.image_url != nil
					redirect_to(:back) and return
				else
					render json: {ok: true} and return
				end
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
		excursion = Excursion.find_or_create_by(event_id: params[:id], user_id: current_user.id)
		excursion.update_attributes accepted: true
		render :nothing => true, :status => 200, :content_type => 'text/html'
	end

	def pass
		excursion = Excursion.find_or_create_by(event_id: params[:id], user_id: current_user.id)
		excursion.update_attributes passed: true
		render :nothing => true, :status => 200, :content_type => 'text/html'
	end

	def chat
		@event = Event.find params[:id]
		@conversation = Conversation.find_or_create_by(event_id: @event.id)
		@message = Message.new
		@locked = (params[:locked] == "true")
		render layout: false
	end
end