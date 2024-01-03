class ConversationsController < ApplicationController
    before_action :authenticate_user! # if followed step 2
  
    def index
        @users = User.all
        @conversations = Conversation.all.order(updated_at: :desc)
    end
    def create  
        if Conversation.between(params[:sender_id], params[:recipient_id]).present? 
            @conversation = Conversation.find_by(sender_id: params[:sender_id], recipient_id: params[:recipient_id])
        else
            @conversation = Conversation.create!(conversation_params)
        end
        redirect_to conversation_messages_path(@conversation)
    end
    private
    def conversation_params
        params.permit(:sender_id, :recipient_id)
    end
end
