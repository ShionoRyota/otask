class UsersController < ApplicationController
	protect_from_forgery except: :pay #payのCSRF対策が無効
  before_action :authenticate_user!, except: [:index] # index以外はログイン済ユーザーのみにアクセスを許可する
  before_action :no_card?, except: [:show, :pay] # show,pay以外はクレカ登録してるか確認(課金者以外排除)

# ホーム画面
	def index
		@login_user = User.find(current_user[:id])
    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.zone.now.all_day).sum(:sale)
    @user.update(sales: @task)
    @tasks = Task.where(user_id: @user, sale_time: Time.zone.now.all_month).sum(:sale)
    @taskss = Task.where(user_id: @user, sale_time: Time.zone.now.all_year).sum(:sale)
	end

# user登録の記入内容確認画面
	def show
    @user = User.find(current_user[:id])
	end

# 売上履歴
  def sale_history
    @login_user = User.find(current_user[:id])
  end


# pay.jpと連携
	def pay
     Payjp.api_key = 'sk_test_da41c1a67e47faa9c167e35f'

     customer = Payjp::Customer.create(
      description: 'test'
     )

     @user = User.find(current_user[:id])
     @user.customer_id = customer['id']
     @user.save



     plan = Payjp::Plan.create(
      amount: 2280,
      currency: 'jpy',
      interval: 'month',
      name: 'otask',
      trial_days: 30
    )


     Payjp::Subscription.create(
      plan: plan,
      customer: customer
     )

     charge = Payjp::Charge.create(
       :amount => 2280,
       :card => params['payjp-token'],
       :currency => 'jpy'
     )


    redirect_to users_path

    flash[:notice] = "支払い完了"

  end

# 収支管理
  def income_and_expenditure
    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.zone.now.all_day).sum(:sale)
    @user.update(sales: @task)
    @tasks = Task.where(user_id: @user, sale_time: Time.zone.now.all_month).sum(:sale)
    @taskss = Task.where(user_id: @user, sale_time: Time.zone.now.all_year).sum(:sale)
  end

# 支出管理
  def expenditure
  end

# 支出履歴
  def expenditure_history
    @login_user = User.find(current_user[:id])
  end
#クレジット登録しているか確認
  def no_card?
      @current_user = User.find(current_user[:id])
      if @current_user.customer_id.nil?
        redirect_to "/users/sign_in"
      end
  end

  # 売上履歴（できれば一つにまとめたい）
  def expenditure_one_month
    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.new(2019,01,01).beginning_of_month..Time.new(2019,01,31).end_of_month).sum(:sale)
    @lists = current_user.lists.all
  end

  def expenditure_two_month
    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.new(2019,02,01).beginning_of_month..Time.new(2019,02,28).end_of_month).sum(:sale)
    @lists = current_user.lists.all
  end

  def expenditure_three_month
    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.new(2019,03,01).beginning_of_month..Time.new(2019,03,31).end_of_month).sum(:sale)
    @lists = current_user.lists.all
  end

  def expenditure_four_month
    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.new(2019,04,01).beginning_of_month..Time.new(2019,04,30).end_of_month).sum(:sale)
    @lists = current_user.lists.all
  end

  def expenditure_five_month
    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.new(2019,05,01).beginning_of_month..Time.new(2019,05,31).end_of_month).sum(:sale)
    @lists = current_user.lists.all
  end

  def expenditure_six_month
    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.new(2019,06,01).beginning_of_month..Time.new(2019,06,30).end_of_month).sum(:sale)
    @lists = current_user.lists.all
  end

  def expenditure_seven_month
    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.new(2019,07,01).beginning_of_month..Time.new(2019,07,31).end_of_month).sum(:sale)
    @lists = current_user.lists.all
  end

  def expenditure_eight_month
    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.new(2019,8,01).beginning_of_month..Time.new(2019,8,31).end_of_month).sum(:sale)
    @lists = current_user.lists.all
  end

  def expenditure_nine_month
    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.new(2018,9,01).beginning_of_month..Time.new(2018,9,30).end_of_month).sum(:sale)
    @lists = current_user.lists.all
  end

  def expenditure_ten_month
    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.new(2018,10,01).beginning_of_month..Time.new(2018,10,31).end_of_month).sum(:sale)
    @lists = current_user.lists.all
  end

  def expenditure_eleven_month
    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.new(2018,11,01).beginning_of_month..Time.new(2018,11,30).end_of_month).sum(:sale)
    @lists = current_user.lists.all
  end

  def expenditure_twelve_month
    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.new(2018,12,01).beginning_of_month..Time.new(2018,12,31).end_of_month).sum(:sale)
    @lists = current_user.lists.all
  end

end
