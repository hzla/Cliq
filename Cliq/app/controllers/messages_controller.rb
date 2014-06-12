class MessagesController < ApplicationController
	include SessionsHelper


	def index
		@conversation = current_user.ordered_conversations.first
		@message = Message.new(user_id: current_user.id, conversation_id: @conversation.id)
		@conversation.update_notifications current_user
	end


	def create
		@message = Message.new params[:message]
		@message.user_id = current_user.id
		@message.conversation_id = params[:conversation_id]
		@conversation = Conversation.find(params[:conversation_id])
		@user = @conversation.get_other_user current_user
		p @user 
		@user.message_count += 1
		@user.save
		@message.save
	end

	private
end