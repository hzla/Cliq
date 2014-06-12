class ConversationsController < ApplicationController
include SessionsHelper

	def show
		@conversation = Conversation.find params[:id]
		@message = Message.new(user_id: current_user.id, conversation_id: @conversation.id)
		@user = current_user
		@conversation.update_notifications current_user
		render layout: false
	end

end