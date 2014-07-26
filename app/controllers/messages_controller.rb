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
	end

	def create
		@message = Message.new params[:message]
		@message.user_id = current_user.id
		@message.conversation_id = params[:conversation_id]
		@conversation = Conversation.find(params[:conversation_id])
		@conversation.update_attributes connected: true
		@user = @conversation.get_other_user current_user

		if @message.save && !current_user.blocked_by?(@user)
			@user.message_count += 1 
			@user.save
			broadcast user_path(@user)+ "/messages", @message.to_json
			other_connection = Connection.where(conversation_id: params[:conversation_id], user_id: @user.id).first
			if @user.notify_messages && !@user.using && !other_connection.emailed
				other_connection.update_attributes emailed: true
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