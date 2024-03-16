Rails.application.routes.draw do
  # Define resources for rooms and nested resources for messages
  resources :rooms do 
    resources :messages
  end
  
  # Define the root path route to point to the 'home' action of the 'pages' controller
  root 'pages#home'
  
  # Configure Devise routes and controllers for user authentication
  # The controllers option allows you to customize which controllers Devise should use for specific authentication actions.
  # For Example, the sessions controller, authentication-related actions like signing in and signing out are handled. Here, it's specified that the users/sessions controller should be used.
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: "users/registrations"
  }

  
  # Define a route for users to access the sign-in page
  # devise_scope :user do
  #   get 'users', to: 'devise/sessions#new'
  # end
  
  # Define a route for accessing user profiles
  get 'user/:id', to: 'users#show', as: 'user'
  
  # Route to reveal the health status of the application
  get "up" => "rails/health#show", as: :rails_health_check
  
  # Defines the root path route ("/")
  # root "posts#index"
end
