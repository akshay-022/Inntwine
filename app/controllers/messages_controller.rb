class MessagesController < ApplicationController
  before_action :find_conversation_and_mark_read, only: [:index]
    before_action do
        @conversation = Conversation.find(params[:conversation_id])
      end
      
      def index
        @messages = @conversation.messages
        @message = @conversation.messages.new
        # Check if the current user is the sender or recipient
        if current_user == @conversation.sender
          # If the current user is the sender, mark sender_unread as false
          @conversation.update(sender_unread: false)
        elsif current_user == @conversation.recipient
          # If the current user is the recipient, mark recipient_unread as false
          @conversation.update(recipient_unread: false)
        end
      end

      def find_conversation_and_mark_read
        @conversation = Conversation.find(params[:conversation_id])
    
        if current_user == @conversation.sender
          @conversation.update(sender_unread: false)
        elsif current_user == @conversation.recipient
          @conversation.update(recipient_unread: false)
        end
      end

      def new
        @message = @conversation.messages.new
      end
      def create
        @message = @conversation.messages.new(message_params)
        if @message.save
          if current_user == @conversation.sender
            # If the current user is the sender, mark recipient_unread as true
            @conversation.update(recipient_unread: true)
          elsif current_user == @conversation.recipient
            # If the current user is the recipient, mark sender_unread as true
            @conversation.update(sender_unread: true)
          end
          if !@conversation.started
            # If it was empty, set :started to true
            @conversation.update(started: true)
          end
          redirect_to conversation_messages_path(@conversation)
        end
      end
      private
      def message_params
        params.require(:message).permit(:body, :user_id)
      end
end
