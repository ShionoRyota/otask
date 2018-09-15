Rails.application.routes.draw do
  devise_for :users
  resources :users
  resources :lists do
  	resources :tasks
  end

  put '/tasks/:id/todo', to: 'tasks#todo'
  put '/tasks/:id/doing', to: 'tasks#doing'
  put '/tasks/:id/finish', to: 'tasks#finish'


  root to: 'users#index'
end
