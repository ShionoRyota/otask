Rails.application.routes.draw do
  devise_for :users
  resources :users
  resources :lists do
  	resources :tasks do
  	member do
    put 'todo'
    put 'doing'
    put 'finish'
    end
    end
  end

  root to: 'users#index'
end
