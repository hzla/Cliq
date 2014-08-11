class MessagesController < ApplicationController
	include SessionsHelper
	include ApplicationHelper
	include ActionView::Helpers::JavaScriptHelper

	def index
		@conversation = current_user.ordered_conversations.first
		if @conversation 
			@message = Message.new(user_id: current_user.id, conversation_id: @conversation.id)
			@conversation.update_notifications current_user
			@other_user = @conversation.get_other_user current_user
		else
		end
		respond_to do |format|
        format.html { render :layout => !request.xhr? }
        # other formats
    end
	end

	def create
		@message = Message.new params[:message]
		@message.user_id = current_user.id
		@message.conversation_id = params[:conversation_id]
		@conversation = Conversation.find(params[:conversation_id])
		@user = @conversation.get_other_user current_user
		if @message.save && !current_user.blocked_by?(@user)
			@conversation.update_attributes initiated: true
			@conversation.update_attributes connected: true if (@conversation.connected == false) && @conversation.messages.map(&:user_id).include?(@user.id)
			@user.message_count += 1 
			@user.save
			broadcast user_path(@user)+ "/messages", @message.to_json
			other_connection = Connection.where(conversation_id: params[:conversation_id], user_id: @user.id).first
			p @user.notify_messages
			p (!@user.active || !@user.using)
			p !other_connection.emailed
			puts "\n%" * 50
			if @user.notify_messages && (!@user.active || !@user.using) && !other_connection.emailed
				other_connection.update_attributes emailed: true
				puts "emailed" * 100
				puts "\n" * 20
				MessageMailerWorker.perform_async @user.id, current_user.id
				#NotificationMailer.notification(@user, current_user).deliver if @user.email
			end
		end
		
		
	end

	def show
		@message = Message.find params[:id]
		@message.conversation.update_notifications current_user
		render partial: 'show', locals: {message: @message}
	end

	private
end