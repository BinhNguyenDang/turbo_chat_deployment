class Room < ApplicationRecord
    # Validates the uniqueness of the room name
    validates_uniqueness_of :name
    
    # Defines a scope to fetch public rooms
    scope :public_rooms, -> { where(is_private: false) }
    
    # Sets up a callback to broadcast a message after a new room is created
    after_create_commit { broadcast_if_public }
    
    # Establishes an association: a room has many messages
    has_many :messages

     # Establishes an association: a room has many participants
    has_many :participants, dependent: :destroy

    # Method to broadcast a message after a new room is created if it's public
    def broadcast_if_public
      broadcast_append_to "rooms" unless self.is_private
    end

    # Method to create a private room and add participants
    def self.create_private_room(users, room_name)
      single_room = Room.create(name: room_name, is_private: true)
      users.each do |user|
        Participant.create(user_id: user.id, room_id: single_room.id)
      end
      return single_room
    end
    # Checks if a user is a participant in a room.
    def participant?(room, user)
      room.participants.where(user: user).exists?
    end
end
  