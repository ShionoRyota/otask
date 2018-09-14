Rails.application.routes.draw do
  devise_for :users
  resources :users
  resources :lists
  resources :tasks
  put "set_task", to: 'tasks#set_task'
  root to: 'users#index'
end
