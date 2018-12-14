Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations',
                                    confirmations: 'users/confirmations',
                                    unlocks:       'users/unlocks',
                                    passwords:     'users/passwords' }

  devise_scope :user do
    get 'confirm_email', to: 'users/registrations#confirm_email'
  end

#売上履歴
  get 'lists/sale_months' => "lists#sale_months"



  resources :lists do
    get 'tasks/invoice' => "tasks#invoice"
    get 'tasks/ahead' => "tasks#ahead"
    get 'tasks/delnote' => "tasks#delnote"
  #売上履歴
    get 'tasks/sale_detail' => "tasks#sale_detail"
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
  delete '/pay_delete' => "users#pay_delete"
  get 'users/delete_confirm' => "users#delete_confirm"
  get 'users/delete_done' => "users#delete_done"
  get 'users/billed' => "users#billed" #請求みの仕事で本日の履歴か全部の履歴かを選択する画面
  get 'users/billed_today' => "users#billed_today"
  get 'lists/show' => "lists#show" #請求済みの仕事のlistを表示
  get 'tasks/show' => "tasks#show" # 請求済みの仕事のtaskの表示

#支出履歴
  get 'users/expenditure_months' => "users#expenditure_months"


end
