class RoomsController < ApplicationController
  # Ensure that the user is authenticated before executing any action
  before_action :authenticate_user!
  before_action :set_status
  
  def index
    # Initialize a new instance of the Room model
    @rooms = Room.new
    # Retrieve public rooms using the public_rooms scope (definition in room.rb)
    @rooms = Room.public_rooms
    
    # Fetch all users except the current user, all_except scope ( definition in user.rb)
    @users = User.all_except(current_user)
    
    # Render the 'index' template
    render 'index'
  end
  
  def show
    # Find the room with the specified ID
    @single_room = Room.find(params[:id])
    
    # Initialize a new instance of the Room model
    @rooms = Room.new
    # Retrieve public rooms using the public_rooms scope
    @rooms = Room.public_rooms
    
    # Initialize a new instance of the Message model
    @message = Message.new
    
    # Fetch messages associated with the single room
    # @messages = @single_room.messages.order(created_at: :asc)
    pagy_messages = @single_room.messages.order(created_at: :desc)
    @pagy, messages = pagy(pagy_messages, items: 10)
    @messages = messages.reverse
    
    
    # Fetch all users except the current user
    @users = User.all_except(current_user)
    
    # Render the 'index' template
    render 'index'
  end
  
  def create
    # Create a new room with the name specified in the params
    @room = Room.create(name: params["name"])
    
    # Print the @room object to the console for debugging
    puts @room.inspect
  end


  private

  def set_status
    current_user.update!(status: User.statuses[:online]) if current_user
  end
end
