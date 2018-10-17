Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations',
                                    confirmations: 'users/confirmations',
                                    passwords:     'users/passwords',
                                    unlocks:       'users/unlocks' }

  devise_scope :user do
    get 'confirm_email', to: 'users/registrations#confirm_email'
  end

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

    get 'tasks/color' => "tasks#color"

    get 'tasks/one_detail' => "tasks#one_detail"
    get 'tasks/two_detail' => "tasks#two_detail"
    get 'tasks/three_detail' => "tasks#three_detail"
    get 'tasks/four_detail' => "tasks#four_detail"
    get 'tasks/five_detail' => "tasks#five_detail"
    get 'tasks/six_detail' => "tasks#six_detail"
    get 'tasks/seven_detail' => "tasks#seven_detail"
    get 'tasks/eight_detail' => "tasks#eight_detail"
    get 'tasks/nine_detail' => "tasks#nine_detail"
    get 'tasks/ten_detail' => "tasks#ten_detail"
    get 'tasks/eleven_detail' => "tasks#eleven_detail"
    get 'tasks/twelve_detail' => "tasks#twelve_detail"
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
