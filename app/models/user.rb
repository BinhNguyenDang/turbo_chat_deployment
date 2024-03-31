class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  # Define a scope to fetch all users except the current user
  scope :all_except, ->(user) { where.not(id: user)}
  

  has_one_attached :avatar
  after_commit :add_default_avatar, on: %i[create update]
  # Define a callback to broadcast a message after a user is created
  # Show new user tab bar once a users is sign up in real time
  # append to "users" in div with users id in the index.html.erb
  after_create_commit { broadcast_append_to "users" }
  # Define a callback to broadcast an update after a user is created (def function below)
  after_update_commit :broadcast_status_update, if: :saved_change_to_status?
  # Define association: a user has many messages
  has_many :messages
  # Define an Active Storage attachment for user avatars
  
  # Define an enumeration for user status with three possible values: offline, away, and online
  # Rails creates a method called statuses on the User model, which returns a hash-like object. This object maps each enum value (e.g., :offline, :away, :online) to its corresponding integer value.
  enum status: %i[offline away online]

  # Define a callback to add a default avatar (if none is attached) after a user is created or updated
  # When a new user is created (create event) or an existing user is updated (update event), the add_default_avatar method will be invoked.
  
  # Generates a resized thumbnail of the user's avatar
  def avatar_thumbnail
    avatar.variant(resize_to_limit: [150,150]).processed
  end
   # Generates a resized avatar for use in chat
  def chat_avatar
    avatar.variant(resize_to_limit: [50,50]).processed
  end

  # Broadcasts an update to the user's status
  def broadcast_status_update
    Turbo::StreamsChannel.broadcast_replace_to(
      "user_status:#{self.id}",
      target: "user_status_#{self.id}",
      partial: "users/status",
      locals: { user: self }
    )
  end
   # Maps user status to corresponding CSS class for styling
  def status_to_css
    case status
    when 'online'
      'bg-success'
    when 'away'
      'bg-warning'
    when 'offline'
      'bg-dark'
    else
      'bg-dark'
    end
  end

  private
   # Adds a default avatar if none is attached
  def add_default_avatar
    return if avatar.attached?

      avatar.attach(
        io:File.open(Rails.root.join('app', 'assets', 'images', 'default_profile.jpg')),
        filename: 'default_profile.jpg',
        content_type: 'image/jpg'
      )
  end
end

