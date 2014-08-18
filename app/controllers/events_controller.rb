class EventsController < ApplicationController #in severe need of refactoring
	include SessionsHelper
	include ApplicationHelper
	skip_before_filter  :verify_authenticity_token

	def index
		excursions = current_user.excursions 
		@open = true
		excursions.update_all seen: true
		respond_to do |format|
        format.html { render :layout => !request.xhr? }
    end
	end

	def hosted
		@events = Event.hosted_by current_user
		if request.variant == [:phone]
			render partial: 'mobile_events', locals: {events: @events, open: "create"}
		else
			render partial: 'events', locals: {events: @events, open: true}
		end
	end

	def past
		@events = Event.past current_user
		if request.variant == [:phone]
			render partial: 'mobile_events', locals: {events: @events}
		else
			render partial: 'events', locals: {events: @events}
		end
	end

	def going
		@events = Event.joined_by current_user
		@open = false
		if request.variant == [:phone]
			render partial: 'mobile_events', locals: {events: @events, open: @open}
		else
			render partial: 'events', locals: {events: @events, open: @open}
		end
	end

	def open
		@events = Event.open current_user
		@open = true
		if request.variant == [:phone]
			render partial: 'mobile_events', locals: {events: @events, open: @open}
		else
			render partial: 'events', locals: {events: @events, open: @open}
		end
	end

	def new
		@event = Event.new
		@user = User.find params[:user_id] 
		@partners = Partner.local_options
		render layout: false
	end

	def public_new
		@event = Event.new
		@user = current_user
		@partners = Partner.local_options
		render layout: false
	end

	def public_create
		p params
		puts "\n" * 50
		if browser.mobile?
			event = Event.new params[:event]
		else
			event = Event.assign_and_return_new params
		end
		if event.save
			if !browser.mobile?
				if params[:event][:start_time].include? "pm"
					pm = true
				end
				pm ? event.start_time += 12.hours : nil
			end
			event.start_time -= current_user.timezone.hours
			event.users << [current_user]
			excursion = Excursion.where(event_id: event.id, user_id: current_user.id)[0]
			excursion.update_attributes created: true, accepted: true
			event.save
			if event.image_url != nil
				redirect_to(:back) and return
			end
			if request.variant == [:phone]
				render json: {ok: true} and return
			end
			render json: {ok: true} and return	
		else
			render json: event.errors and return
		end
		render json: {ok: true}
	end

	def create
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
			render json: event.errors and return
		end
		redirect_to events_path
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
		decrease_count = @conversation.was_seen_by current_user
		current_user.update_attributes(invite_count: 0) if decrease_count
		render layout: false
	end
end