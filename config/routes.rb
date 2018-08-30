Rails.application.routes.draw do
  devise_for :users
  resources :users
  resources :lists
  resources :tasks

  root to: 'users#index'
end
