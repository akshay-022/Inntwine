require 'sidekiq/web'

Rails.application.routes.draw do
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

  resources :posts, except: [:edit, :update] do         #All these are based on your feed. Can't show everything in the world at once
    resources :comments, only: [:create, :destroy]
    member do
      post :repost
    end
  end

  resources :profiles
  resources :likes, only: :create
  resources :connections
  resources :communities
  resources :messages

  devise_for :users
  root to: "posts#index"
end
