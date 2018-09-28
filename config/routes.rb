Rails.application.routes.draw do
  devise_for :users
  get 'lists/one_month' => "lists#one_month"
  get 'lists/two_month' => "lists#two_month"
  get 'lists/three_month' => "lists#three_month"
  get 'lists/four_month' => "lists#four_month"
  get 'lists/five_month' => "lists#five_month"
  get 'lists/six_month' => "lists#six_month"
  get 'lists/seven_month' => "lists#seven_month"
  get 'lists/eight_month' => "lists#eight_month"
  get 'lists/nine_month' => "lists#nine_month"
  get 'lists/ten_month' => "lists#ten_month"
  get 'lists/eleven_month' => "lists#eleven_month"
  get 'lists/twelve_month' => "lists#twelve_month"
  resources :lists do
  	get 'tasks/invoice' => "tasks#invoice"
  	get 'tasks/ahead' => "tasks#ahead"
  	get 'tasks/delnote' => "tasks#delnote"
  	resources :tasks do
  	member do
    put 'todo'
    put 'doing'
    put 'finish'

    put 'sale'
    put 'task_clear'
    end
    end
  end
  root to: 'users#index'
  get 'users' => "users#index"
  get 'users/show' => "users#show"
  get 'users/sale_history', to: 'users#sale_history'

  post '/pay' => "users#pay"
  get 'lists/show' => "lists#show"
  get 'tasks/show' => "tasks#show"

end
