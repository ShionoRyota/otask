Rails.application.routes.draw do
  devise_for :users
  resources :users
  resources :lists do
    get 'tasks/a' => "tasks#a"
  	resources :tasks do
  	member do
    put 'todo'
    put 'doing'
    put 'finish'

    put 'sale'
    end
    end
  end
  root to: 'users#index'
  get 'users/show' => "users#show"
  post '/pay' => "users#pay"
  get 'lists/show' => "lists#show"
  get 'tasks/show' => "tasks#show"

end
