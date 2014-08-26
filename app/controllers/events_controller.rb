class EventsController < ApplicationController #in severe need of refactoring
	include SessionsHelper
	include ApplicationHelper
	skip_before_filter  :verify_authenticity_token

	def index
		excursions = current_user.excursions 
		@open = true
		@welcome = params[:welcome]
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

	def public_new
		@event = Event.new
		@user = current_user
		render layout: false
	end

	# creates new event using custom assign_and_return_new event method if on desktop
	# desktop ui widget doesn't distinguish between am and pm so if on desktop, adjust time by 12 hours 
	# if time is pm, time is then converted to utc time by adjusting by user timezone
	# if there's an image, refresh is inevitable so redirect to back
	# render ok true if ok, and errors if not
	def public_create
		event = Event.assign_and_return_new params
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
			redirect_to events_path and return	
		else
			render json: event.errors
		end
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
		respond_to do |format|
      format.html { render :layout => !request.xhr? }
    end
	end
end