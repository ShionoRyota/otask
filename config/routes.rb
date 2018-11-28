Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations',
                                    confirmations: 'users/confirmations',
                                    unlocks:       'users/unlocks' }

  devise_scope :user do
    get 'confirm_email', to: 'users/registrations#confirm_email'
  end

#売上履歴
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
  #売上履歴
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
    put 'todo' #TODOボタン
    put 'doing' #作業中ボタン
    put 'finish' #完了ボタン
    put 'sale' #請求ボタン
    put 'task_clear' #履歴に残すボタン
    get 'download' #task,editの画像拡大
    end
    end
  end

 resources :expenditures do
 end
  root to: 'users#index'

  #検討
  get 'users' => "users#index"

  get 'users/show' => "users#show" # user登録の記入内容確認画面
  get 'users/sale_history', to: 'users#sale_history' #売上履歴
  get 'users/income_and_expenditure', to: 'users#income_and_expenditure' #収支管理
  get 'users/expenditure', to: 'users#expenditure' #収支管理
  get 'users/expenditure_history', to: 'users#expenditure_history' #収支管理
  post '/pay' => "users#pay" # pay.jp連携
  get 'lists/show' => "lists#show" #請求済みの仕事のlistを表示
  get 'tasks/show' => "tasks#show" # 請求済みの仕事のtaskの表示

#支出履歴
  get 'users/expenditure_one_month' => "users#expenditure_one_month"
  get 'users/expenditure_two_month' => "users#expenditure_two_month"
  get 'users/expenditure_three_month' => "users#expenditure_three_month"
  get 'users/expenditure_four_month' => "users#expenditure_four_month"
  get 'users/expenditure_five_month' => "users#expenditure_five_month"
  get 'users/expenditure_six_month' => "users#expenditure_six_month"
  get 'users/expenditure_seven_month' => "users#expenditure_seven_month"
  get 'users/expenditure_eight_month' => "users#expenditure_eight_month"
  get 'users/expenditure_nine_month' => "users#expenditure_nine_month"
  get 'users/expenditure_ten_month' => "users#expenditure_ten_month"
  get 'users/expenditure_eleven_month' => "users#expenditure_eleven_month"
  get 'users/expenditure_twelve_month' => "users#expenditure_twelve_month"


end
