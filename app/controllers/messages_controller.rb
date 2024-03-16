class MessagesController < ApplicationController
    def create
      # Create a new message associated with the current user
      @message = current_user.messages.create(
      body: msg_params[:body],
      room_id: params[:room_id],
      attachments: msg_params[:attachments]
    )
    end
    
    private
    
    # Strong parameters method to ensure only permitted attributes are allowed
    def msg_params
      params.require(:message).permit(:body, attachments: [])
    end
  end
  