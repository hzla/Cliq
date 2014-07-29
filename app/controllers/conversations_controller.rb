class ConversationsController < ApplicationController
include SessionsHelper

	def show
		@conversation = Conversation.find params[:id]
		@message = Message.new(user_id: current_user.id, conversation_id: @conversation.id)
		@user = current_user
		# @conversation.update_notifications current_user
		@other_user = @conversation.get_other_user current_user
		render layout: false
	end


	def chat
		@other_user = User.find params[:user_id]
		@message = Message.new
		potential_convo = current_user.talked_to?(@other_user)
		if !potential_convo
			@conversation = Conversation.create name: "#{current_user.id}-#{@other_user.id}"
			@conversation.users << [current_user, @other_user]
			@conversation.save
		else
			@conversation = potential_convo
		end
		@message = Message.new(user_id: current_user.id, conversation_id: @conversation.id)
		render layout: false
	end

end