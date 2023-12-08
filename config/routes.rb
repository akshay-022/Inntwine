require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  resources :organizations do 
    resources :topics do
      resources :posts, except: [:edit, :update] do
        resources :comments, only: [:create, :destroy]
        member do
          post :repost
        end
      end
    end
  end
  
  resources :posts, except: [:edit, :update] do
    resources :comments, only: [:create, :destroy]
    member do
      post :repost
    end
  end

  resources :profiles
  resources :likes, only: :create

  devise_for :users
  root to: "posts#index"
end
