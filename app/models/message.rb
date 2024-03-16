class Message < ApplicationRecord
  # Establishes a belongs_to association with the User model
  belongs_to :user
  
  # Establishes a belongs_to association with the Room model
  belongs_to :room
  has_many_attached :attachments, dependent: :destroy
  # Defines a callback to broadcast a message after a new message is created
  #self.room: This refers to the room associated with the message that triggered the callback. 
  #By calling self.room, it retrieves the associated room record.
  after_create_commit { broadcast_append_to self.room }

  # Before creating a new room, confirm the participant
  before_create :confirm_participant


  def chat_attachment(index)
    target = attachments[index]
    return unless attachments.attached?

    if target.image?
      target.variant(resize_to_limit: [150, 150]).processed
    elsif target.video?
      target.variant(resize_to_limit: [150, 150]).processed
    end
  end

  # Method to confirm if the participant is allowed to create the room
  def confirm_participant
    # Check if the room is private
    return unless room.is_private

    # Check if the user creating the room is a participant
    is_participant = Participant.where(user_id: self.user.id, room_id: self.room.id).first

    # Abort room creation if the user is not a participant
    throw :abort unless is_participant
  end
end
