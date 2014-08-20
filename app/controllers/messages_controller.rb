	class MessagesController < ApplicationController
	include SessionsHelper
	include ApplicationHelper
	include ActionView::Helpers::JavaScriptHelper

	def index
		respond_to do |format|
      format.html { render :layout => !request.xhr? }
    end
	end

	def create
		@message = Message.new params[:message]
		@message.user_id = current_user.id
		@message.conversation_id = params[:conversation_id]
		@conversation = Conversation.find(params[:conversation_id])
		@user = @conversation.get_other_user current_user
		if @message.save && !current_user.blocked_by?(@user) 
			if !params[:event] == "true" || !params[:event]
				@conversation.update_attributes initiated: true
				@conversation.update_attributes connected: true if (@conversation.connected == false) && @conversation.messages.map(&:user_id).include?(@user.id)
				@user.message_count += 1 
				@user.save
				broadcast user_path(@user)+ "/messages", @message.to_json
				other_connection = Connection.where(conversation_id: params[:conversation_id], user_id: @user.id).first
				if @user.notify_messages && (!@user.active || !@user.using) && !other_connection.emailed
					other_connection.update_attributes emailed: true
					MessageMailerWorker.perform_async @user.id, current_user.id
				end
			else
				@conversation.email_all_others current_user
				@conversation.clear_seen_by current_user
				event = @conversation.event
				event.messages_count += 1
				event.save
				@conversation.all_others(current_user).each do |user|
					broadcast user_path(user) + "/messages", @message.to_json
				end
			end
		end	
		@event_message = (params[:event] == "true")	
	end

	def show
		@message = Message.find params[:id]
		conversation = @message.conversation
		conversation.update_notifications current_user
		@event_image = (conversation.event_id != nil)
		render partial: 'show', locals: {message: @message, event_image: @event_image}
	end

end