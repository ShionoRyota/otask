Rails.application.routes.draw do
  devise_for :users
  resources :users
<<<<<<< HEAD
  resources :lists
  resources :tasks
  put "set_task", to: 'tasks#set_task'
=======
  resources :lists do
  	resources :tasks
  end

>>>>>>> 24d133db29d3e3d9c446cfb823d1b7301e0d1753
  root to: 'users#index'
end
