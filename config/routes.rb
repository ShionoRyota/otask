Rails.application.routes.draw do
  devise_for :users
  resources :users
  resources :lists do
  	resources :tasks
  end

  root to: 'users#index'
end
