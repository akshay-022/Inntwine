require 'sidekiq/web'

Rails.application.routes.draw do
  resources :conversations
  resources :user_organizations
  resources :topics
  resources :organizations
  resources :moderators
  resources :communities
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  resources :organizations do 
    resources :topics do
      resources :posts, except: [:edit, :update] do     #These are for communities. Show all the posts in that community, irrespective of who follows who etc.
        resources :comments, only: [:create, :destroy]
        member do
          post :repost
        end
      end
    end
  end

  resources :feed
  
  resources :posts, except: [:edit, :update] do         #All these are based on your feed. Can't show everything in the world at once
    patch 'moderation', on: :member
    resources :comments, only: [:create, :destroy]
    member do
      post 'update_options'
      post :repost
    end
  end
  

  resources :profiles
  resources :likes, only: :create
  resources :connections do
    patch 'accept', on: :member
    resources :topics
  end

  resources :moderators
  get '/moderator/show_all/:user_id', to: 'moderators#show_all', as: 'moderator_show_all'


  resources :communities do
      post 'join_community', on: :collection
      resources :topics
  end

  resources :conversations do
    resources :messages
  end

  post 'switch_organization/:organization_id/:topic_id', to: 'organizations#switch_organization', as: :switch_organization

  post 'send_connection', to: 'connections#send_connection', as: 'send_connection'

  #devise_for :users
  devise_for :users, controllers: {
  registrations: 'users/registrations'
  }
  root to: "feed#index"
end
