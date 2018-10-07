class UsersController < ApplicationController
	protect_from_forgery except: :pay
  before_action :authenticate_user!, except: [:index]
  before_action :no_card?, except: [:show, :pay]

	def index
		@login_user = User.find(current_user[:id])
    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.zone.now.all_day).sum(:sale)
    @user.update(sales: @task)
    @tasks = Task.where(user_id: @user, sale_time: Time.zone.now.all_month).sum(:sale)
    @taskss = Task.where(user_id: @user, sale_time: Time.zone.now.all_year).sum(:sale)
	end

	def show
    @user = User.find(current_user[:id])
	end

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

  def sale_history
    @login_user = User.find(current_user[:id])
  end

  def no_card?
      @current_user = User.find(current_user[:id])
      if @current_user.customer_id.nil?
        redirect_to "/users/sign_in"
      end
  end

end
