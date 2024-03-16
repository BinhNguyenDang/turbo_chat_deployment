class UsersController < ApplicationController
  def show
    # Find the user by ID
    @user = User.find(params[:id])
    
    # Get all users except the current user (custom scope in user.rb)
    @users = User.all_except(current_user)

    # Initialize a new room
    @room = Room.new
    
    # Fetch public rooms (custom scope in room.rb)
    @rooms = Room.public_rooms
    
    # Generate or find the private room between current user and the user whose profile is being viewed
    @room_name = get_name(@user, current_user)
    # Find a room with the specified name in the database, or create a new private room (function in room.rb) if it doesn't exist
    @single_room = Room.where(name: @room_name).first || Room.create_private_room([@user, current_user], @room_name)

    # Initialize a new message
    @message = Message.new
    
    # Fetch messages for the single room, ordered by creation time
    # @messages = @single_room.messages.order(created_at: :asc)

    pagy_messages = @single_room.messages.order(created_at: :desc)
    @pagy, messages = pagy(pagy_messages, items: 10)
    @messages = messages.reverse
    
    # Render the 'rooms/index' template
    render 'rooms/index'
  end

  private
  
  # Method to generate a unique private room name based on two users' IDs
  # EXAMPLE : private_1_2 (room for user_id 1 and user_id 2)
  def get_name(user1, user2)
    user = [user1, user2].sort
    "private_#{user[0].id}_#{user[1].id}"
  end
end
