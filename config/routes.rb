Rails.application.routes.draw do
 
  devise_for :users
  root to: 'homes#top'
  get 'home/about' => 'homes#about', as: 'about'
  
  resources :users, only: [:edit, :show, :index, :update] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
    get 'search' => "users#search"
  end
  
  resources :books, only: [:create, :index, :show, :edit, :update, :destroy] do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end 
  
  get 'search' => 'searches#search', as: 'search'
  
  get 'events/index'
  
  resources :messages, only: [:show, :create]
  
  devise_scope :user do
    post "user/guest_sign_in" => 'users/sessions#guest_sign_in'
  end 
  
  resources :notifications, only: [:update]
  
  get '/events' => 'events#index', defaults: { format: 'json' }
  
  resources :groups, only: [:new, :create, :edit, :update, :show, :index, :destroy] do
    resource :group_users, only: [:create, :destroy] 
    get "new/mail" => "groups#new_mail"
    get "send/mail" => "groups#send_mail"
  end
  
  get 'tagsearches/search' => 'tagsearches#search'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
