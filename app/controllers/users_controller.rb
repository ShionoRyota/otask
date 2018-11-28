class UsersController < ApplicationController
<<<<<<< HEAD
	# protect_from_forgery except: :pay #payのCSRF対策が無効
  before_action :authenticate_user!, only: [:index, :show, :pay, :income_and_expenditure, :expenditure, :sale_history, :expenditure_history, :no_card?, :expenditure_one_month, :expenditure_two_month, :expenditure_three_month, :expenditure_four_month, :expenditure_five_month, :expenditure_six_month, :expenditure_seven_month, :expenditure_eight_month, :expenditure_nine_month, :expenditure_ten_month, :expenditure_eleven_month, :expenditure_twelve_month] # index以外はログイン済ユーザーのみにアクセスを許可する
  before_action :no_card?, except: [:show, :pay] # show,pay以外はクレカ登録してるか確認(課金者以外排除)
=======
	protect_from_forgery except: :pay #payのCSRF対策が無効
  before_action :authenticate_user!, except: [:index, :delete_done] # index以外はログイン済ユーザーのみにアクセスを許可する
  before_action :no_card?, except: [:show, :pay, :delete_done] # show,pay以外はクレカ登録してるか確認(課金者以外排除)
>>>>>>> d4ba548a862792825483717237d8ed17b4b9f315

# ホーム画面
	def index
	end

# user登録の記入内容確認画面
	def show
    @user = User.find(current_user[:id])
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
      amount: 2980,
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
       :amount => 2980,
       :card => params['payjp-token'],
       :currency => 'jpy'
     )


    redirect_to users_path

    flash[:notice] = "支払い完了"

  end

  def pay_delete
    Payjp.api_key = 'sk_test_da41c1a67e47faa9c167e35f'
    @user = User.find(current_user[:id])
    pay_id = @user.customer_id
    customer = Payjp::Customer.retrieve(pay_id)
    customer.delete
    @user.destroy
    redirect_to users_delete_done_path
  end

  def delete_confirm
  end

  def delete_done
  end

# 収支管理
  def income_and_expenditure
    @user = User.find(current_user[:id])
    @income_day = Task.where(user_id: @user, sale_time: Time.zone.now.all_day).sum(:sale)
    @income_month = Task.where(user_id: @user, sale_time: Time.zone.now.all_month).sum(:sale)
    @income_year = Task.where(user_id: @user, sale_time: Time.zone.now.all_year).sum(:sale)

    @expenditure_input_day = Expenditure.where(user_id: @user, updated_at: Time.zone.now.all_day).sum(:expenditure_money)
    @material_cost_expenditure_day = Task.where(user_id: @user, sale_time: Time.zone.now.all_day).sum(:material_cost)
    @brokerage_fee_expenditure_day = Task.where(user_id: @user, sale_time: Time.zone.now.all_day).sum(:brokerage_fee)
    @processing_fee_expenditure_day = Task.where(user_id: @user, sale_time: Time.zone.now.all_day).sum(:processing_fee)
    @expenditure_day = @expenditure_input_day + @material_cost_expenditure_day + @brokerage_fee_expenditure_day + @processing_fee_expenditure_day

    @expenditure_input_month = Expenditure.where(user_id: @user, updated_at: Time.zone.now.all_month).sum(:expenditure_money)
    @material_cost_expenditure_month = Task.where(user_id: @user, sale_time: Time.zone.now.all_month).sum(:material_cost)
    @brokerage_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.zone.now.all_month).sum(:brokerage_fee)
    @processing_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.zone.now.all_month).sum(:processing_fee)
    @expenditure_month = @expenditure_input_month + @material_cost_expenditure_month + @brokerage_fee_expenditure_month + @processing_fee_expenditure_month

    @expenditure_input_year = Expenditure.where(user_id: @user, updated_at: Time.zone.now.all_year).sum(:expenditure_money)
    @material_cost_expenditure_year = Task.where(user_id: @user, sale_time: Time.zone.now.all_year).sum(:material_cost)
    @brokerage_fee_expenditure_year = Task.where(user_id: @user, sale_time: Time.zone.now.all_year).sum(:brokerage_fee)
    @processing_fee_expenditure_year = Task.where(user_id: @user, sale_time: Time.zone.now.all_year).sum(:processing_fee)
    @expenditure_year = @expenditure_input_year + @material_cost_expenditure_year + @brokerage_fee_expenditure_year + @processing_fee_expenditure_year

    @profits_day = @income_day - @expenditure_day
    @profits_month = @income_month - @expenditure_month
    @profits_year = @income_year - @expenditure_year

  end


# 支出管理
  def expenditure
  end

# 売上履歴
  def sale_history
  end

# 支出履歴
  def expenditure_history
  end

  # 売上履歴（できれば一つにまとめたい）
  def expenditure_one_month
    @user = User.find(current_user[:id])
    @expenditure_input_month = Expenditure.where(user_id: @user, updated_at: Time.new(2019,01,01).beginning_of_month..Time.new(2019,01,31).end_of_month).sum(:expenditure_money)
    @material_cost_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,01,01).beginning_of_month..Time.new(2019,01,31).end_of_month).sum(:material_cost)
    @brokerage_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,01,01).beginning_of_month..Time.new(2019,01,31).end_of_month).sum(:brokerage_fee)
    @processing_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,01,01).beginning_of_month..Time.new(2019,01,31).end_of_month).sum(:processing_fee)
    @expenditure_month = @expenditure_input_month + @material_cost_expenditure_month + @brokerage_fee_expenditure_month + @processing_fee_expenditure_month

    @expenditures_rent = Expenditure.where(expenditure_item: "家賃・地代", user_id: @user, updated_at: DateTime.new(2019, 01, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 01, 31, 23, 59, 59).end_of_month)
    @expenditures_utility = Expenditure.where(expenditure_item: "光熱費", user_id: @user, updated_at: DateTime.new(2019, 01, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 01, 31, 23, 59, 59).end_of_month)
    @expenditures_personnel = Expenditure.where(expenditure_item: "人件費", user_id: @user, updated_at: DateTime.new(2019, 01, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 01, 31, 23, 59, 59).end_of_month)
    @expenditures_transport = Expenditure.where(expenditure_item: "交通費", user_id: @user, updated_at: DateTime.new(2019, 01, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 01, 31, 23, 59, 59).end_of_month)
    @expenditures_net = Expenditure.where(expenditure_item: "ネット通信費", user_id: @user, updated_at: DateTime.new(2019, 01, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 01, 31, 23, 59, 59).end_of_month)
    @expenditures_loan = Expenditure.where(expenditure_item: "機械ローン", user_id: @user, updated_at: DateTime.new(2019, 01, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 01, 31, 23, 59, 59).end_of_month)
    @expenditures_otherwise = Expenditure.where(expenditure_item: "その他", user_id: @user, updated_at: DateTime.new(2019, 01, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 01, 31, 23, 59, 59).end_of_month)
    @material_cost = Task.where(user_id: @user, sale_time: DateTime.new(2019, 01, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 01, 31, 23, 59, 59).end_of_month)
    @brokerage_fee = Task.where(user_id: @user, sale_time: DateTime.new(2019, 01, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 01, 31, 23, 59, 59).end_of_month)
    @processing_fee = Task.where(user_id: @user, sale_time: DateTime.new(2019, 01, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 01, 31, 23, 59, 59).end_of_month)
  end

  def expenditure_two_month
    @user = User.find(current_user[:id])
    @expenditure_input_month = Expenditure.where(user_id: @user, updated_at: Time.new(2019,02,01).beginning_of_month..Time.new(2019,02,28).end_of_month).sum(:expenditure_money)
    @material_cost_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,02,01).beginning_of_month..Time.new(2019,02,28).end_of_month).sum(:material_cost)
    @brokerage_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,02,01).beginning_of_month..Time.new(2019,02,28).end_of_month).sum(:brokerage_fee)
    @processing_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,02,01).beginning_of_month..Time.new(2019,02,28).end_of_month).sum(:processing_fee)
    @expenditure_month = @expenditure_input_month + @material_cost_expenditure_month + @brokerage_fee_expenditure_month + @processing_fee_expenditure_month

    @expenditures_rent = Expenditure.where(expenditure_item: "家賃・地代", user_id: @user, updated_at: DateTime.new(2019, 02, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 02, 28, 23, 59, 59).end_of_month)
    @expenditures_utility = Expenditure.where(expenditure_item: "光熱費", user_id: @user, updated_at: DateTime.new(2019, 02, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 02, 28, 23, 59, 59).end_of_month)
    @expenditures_personnel = Expenditure.where(expenditure_item: "人件費", user_id: @user, updated_at: DateTime.new(2019, 02, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 02, 28, 23, 59, 59).end_of_month)
    @expenditures_transport = Expenditure.where(expenditure_item: "交通費", user_id: @user, updated_at: DateTime.new(2019, 02, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 02, 28, 23, 59, 59).end_of_month)
    @expenditures_net = Expenditure.where(expenditure_item: "ネット通信費", user_id: @user, updated_at: DateTime.new(2019, 02, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 02, 28, 23, 59, 59).end_of_month)
    @expenditures_loan = Expenditure.where(expenditure_item: "機械ローン", user_id: @user, updated_at: DateTime.new(2019, 02, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 02, 28, 23, 59, 59).end_of_month)
    @expenditures_otherwise = Expenditure.where(expenditure_item: "その他", user_id: @user, updated_at: DateTime.new(2019, 02, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 02, 28, 23, 59, 59).end_of_month)
    @material_cost = Task.where(user_id: @user, sale_time: DateTime.new(2019, 02, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 02, 28, 23, 59, 59).end_of_month)
    @brokerage_fee = Task.where(user_id: @user, sale_time: DateTime.new(2019, 02, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 02, 28, 23, 59, 59).end_of_month)
    @processing_fee = Task.where(user_id: @user, sale_time: DateTime.new(2019, 02, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 02, 28, 23, 59, 59).end_of_month)
  end

  def expenditure_three_month
    @user = User.find(current_user[:id])
    @expenditure_input_month = Expenditure.where(user_id: @user, updated_at: Time.new(2019,03,01).beginning_of_month..Time.new(2019,03,31).end_of_month).sum(:expenditure_money)
    @material_cost_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,03,01).beginning_of_month..Time.new(2019,03,31).end_of_month).sum(:material_cost)
    @brokerage_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,03,01).beginning_of_month..Time.new(2019,03,31).end_of_month).sum(:brokerage_fee)
    @processing_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,03,01).beginning_of_month..Time.new(2019,03,31).end_of_month).sum(:processing_fee)
    @expenditure_month = @expenditure_input_month + @material_cost_expenditure_month + @brokerage_fee_expenditure_month + @processing_fee_expenditure_month

    @expenditures_rent = Expenditure.where(expenditure_item: "家賃・地代", user_id: @user, updated_at: DateTime.new(2019, 03, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 03, 31, 23, 59, 59).end_of_month)
    @expenditures_utility = Expenditure.where(expenditure_item: "光熱費", user_id: @user, updated_at: DateTime.new(2019, 03, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 03, 31, 23, 59, 59).end_of_month)
    @expenditures_personnel = Expenditure.where(expenditure_item: "人件費", user_id: @user, updated_at: DateTime.new(2019, 03, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 03, 31, 23, 59, 59).end_of_month)
    @expenditures_transport = Expenditure.where(expenditure_item: "交通費", user_id: @user, updated_at: DateTime.new(2019, 03, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 03, 31, 23, 59, 59).end_of_month)
    @expenditures_net = Expenditure.where(expenditure_item: "ネット通信費", user_id: @user, updated_at: DateTime.new(2019, 03, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 03, 31, 23, 59, 59).end_of_month)
    @expenditures_loan = Expenditure.where(expenditure_item: "機械ローン", user_id: @user, updated_at: DateTime.new(2019, 03, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 03, 31, 23, 59, 59).end_of_month)
    @expenditures_otherwise = Expenditure.where(expenditure_item: "その他", user_id: @user, updated_at: DateTime.new(2019, 03, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 03, 31, 23, 59, 59).end_of_month)
    @material_cost = Task.where(user_id: @user, sale_time: DateTime.new(2019, 03, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 03, 31, 23, 59, 59).end_of_month)
    @brokerage_fee = Task.where(user_id: @user, sale_time: DateTime.new(2019, 03, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 03, 31, 23, 59, 59).end_of_month)
    @processing_fee = Task.where(user_id: @user, sale_time: DateTime.new(2019, 03, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 03, 31, 23, 59, 59).end_of_month)
  end

  def expenditure_four_month
    @user = User.find(current_user[:id])
    @expenditure_input_month = Expenditure.where(user_id: @user, updated_at: Time.new(2019,04,01).beginning_of_month..Time.new(2019,04,30).end_of_month).sum(:expenditure_money)
    @material_cost_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,04,01).beginning_of_month..Time.new(2019,04,30).end_of_month).sum(:material_cost)
    @brokerage_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,04,01).beginning_of_month..Time.new(2019,04,30).end_of_month).sum(:brokerage_fee)
    @processing_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,04,01).beginning_of_month..Time.new(2019,04,30).end_of_month).sum(:processing_fee)
    @expenditure_month = @expenditure_input_month + @material_cost_expenditure_month + @brokerage_fee_expenditure_month + @processing_fee_expenditure_month

    @expenditures_rent = Expenditure.where(expenditure_item: "家賃・地代", user_id: @user, updated_at: DateTime.new(2019, 04, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 04, 30, 23, 59, 59).end_of_month)
    @expenditures_utility = Expenditure.where(expenditure_item: "光熱費", user_id: @user, updated_at: DateTime.new(2019, 04, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 04, 30, 23, 59, 59).end_of_month)
    @expenditures_personnel = Expenditure.where(expenditure_item: "人件費", user_id: @user, updated_at: DateTime.new(2019, 04, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 04, 30, 23, 59, 59).end_of_month)
    @expenditures_transport = Expenditure.where(expenditure_item: "交通費", user_id: @user, updated_at: DateTime.new(2019, 04, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 04, 30, 23, 59, 59).end_of_month)
    @expenditures_net = Expenditure.where(expenditure_item: "ネット通信費", user_id: @user, updated_at: DateTime.new(2019, 04, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 04, 30, 23, 59, 59).end_of_month)
    @expenditures_loan = Expenditure.where(expenditure_item: "機械ローン", user_id: @user, updated_at: DateTime.new(2019, 04, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 04, 30, 23, 59, 59).end_of_month)
    @expenditures_otherwise = Expenditure.where(expenditure_item: "その他", user_id: @user, updated_at: DateTime.new(2019, 04, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 04, 30, 23, 59, 59).end_of_month)
    @material_cost = Task.where(user_id: @user, sale_time: DateTime.new(2019, 04, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 04, 30, 23, 59, 59).end_of_month)
    @brokerage_fee = Task.where(user_id: @user, sale_time: DateTime.new(2019, 04, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 04, 30, 23, 59, 59).end_of_month)
    @processing_fee = Task.where(user_id: @user, sale_time: DateTime.new(2019, 04, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 04, 30, 23, 59, 59).end_of_month)
  end

  def expenditure_five_month
    @user = User.find(current_user[:id])
    @expenditure_input_month = Expenditure.where(user_id: @user, updated_at: Time.new(2019,05,01).beginning_of_month..Time.new(2019,05,31).end_of_month).sum(:expenditure_money)
    @material_cost_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,05,01).beginning_of_month..Time.new(2019,05,31).end_of_month).sum(:material_cost)
    @brokerage_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,05,01).beginning_of_month..Time.new(2019,05,31).end_of_month).sum(:brokerage_fee)
    @processing_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,05,01).beginning_of_month..Time.new(2019,05,31).end_of_month).sum(:processing_fee)
    @expenditure_month = @expenditure_input_month + @material_cost_expenditure_month + @brokerage_fee_expenditure_month + @processing_fee_expenditure_month

    @expenditures_rent = Expenditure.where(expenditure_item: "家賃・地代", user_id: @user, updated_at: DateTime.new(2019, 05, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 05, 31, 23, 59, 59).end_of_month)
    @expenditures_utility = Expenditure.where(expenditure_item: "光熱費", user_id: @user, updated_at: DateTime.new(2019, 05, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 05, 31, 23, 59, 59).end_of_month)
    @expenditures_personnel = Expenditure.where(expenditure_item: "人件費", user_id: @user, updated_at: DateTime.new(2019, 05, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 05, 31, 23, 59, 59).end_of_month)
    @expenditures_transport = Expenditure.where(expenditure_item: "交通費", user_id: @user, updated_at: DateTime.new(2019, 05, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 05, 31, 23, 59, 59).end_of_month)
    @expenditures_net = Expenditure.where(expenditure_item: "ネット通信費", user_id: @user, updated_at: DateTime.new(2019, 05, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 05, 31, 23, 59, 59).end_of_month)
    @expenditures_loan = Expenditure.where(expenditure_item: "機械ローン", user_id: @user, updated_at: DateTime.new(2019, 05, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 05, 31, 23, 59, 59).end_of_month)
    @expenditures_otherwise = Expenditure.where(expenditure_item: "その他", user_id: @user, updated_at: DateTime.new(2019, 05, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 05, 31, 23, 59, 59).end_of_month)
    @material_cost = Task.where(user_id: @user, sale_time: DateTime.new(2019, 05, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 05, 31, 23, 59, 59).end_of_month)
    @brokerage_fee = Task.where(user_id: @user, sale_time: DateTime.new(2019, 05, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 05, 31, 23, 59, 59).end_of_month)
    @processing_fee = Task.where(user_id: @user, sale_time: DateTime.new(2019, 05, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 05, 31, 23, 59, 59).end_of_month)
  end

  def expenditure_six_month
    @user = User.find(current_user[:id])
    @expenditure_input_month = Expenditure.where(user_id: @user, updated_at: Time.new(2019,06,01).beginning_of_month..Time.new(2019,06,30).end_of_month).sum(:expenditure_money)
    @material_cost_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,06,01).beginning_of_month..Time.new(2019,06,30).end_of_month).sum(:material_cost)
    @brokerage_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,06,01).beginning_of_month..Time.new(2019,06,30).end_of_month).sum(:brokerage_fee)
    @processing_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,06,01).beginning_of_month..Time.new(2019,06,30).end_of_month).sum(:processing_fee)
    @expenditure_month = @expenditure_input_month + @material_cost_expenditure_month + @brokerage_fee_expenditure_month + @processing_fee_expenditure_month

    @expenditures_rent = Expenditure.where(expenditure_item: "家賃・地代", user_id: @user, updated_at: DateTime.new(2019, 06, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 06, 30, 23, 59, 59).end_of_month)
    @expenditures_utility = Expenditure.where(expenditure_item: "光熱費", user_id: @user, updated_at: DateTime.new(2019, 06, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 06, 30, 23, 59, 59).end_of_month)
    @expenditures_personnel = Expenditure.where(expenditure_item: "人件費", user_id: @user, updated_at: DateTime.new(2019, 06, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 06, 30, 23, 59, 59).end_of_month)
    @expenditures_transport = Expenditure.where(expenditure_item: "交通費", user_id: @user, updated_at: DateTime.new(2019, 06, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 06, 30, 23, 59, 59).end_of_month)
    @expenditures_net = Expenditure.where(expenditure_item: "ネット通信費", user_id: @user, updated_at: DateTime.new(2019, 06, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 06, 30, 23, 59, 59).end_of_month)
    @expenditures_loan = Expenditure.where(expenditure_item: "機械ローン", user_id: @user, updated_at: DateTime.new(2019, 06, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 06, 30, 23, 59, 59).end_of_month)
    @expenditures_otherwise = Expenditure.where(expenditure_item: "その他", user_id: @user, updated_at: DateTime.new(2019, 06, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 06, 30, 23, 59, 59).end_of_month)
    @material_cost = Task.where(user_id: @user, sale_time: DateTime.new(2019, 06, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 06, 30, 23, 59, 59).end_of_month)
    @brokerage_fee = Task.where(user_id: @user, sale_time: DateTime.new(2019, 06, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 06, 30, 23, 59, 59).end_of_month)
    @processing_fee = Task.where(user_id: @user, sale_time: DateTime.new(2019, 06, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 06, 30, 23, 59, 59).end_of_month)
  end

  def expenditure_seven_month
    @user = User.find(current_user[:id])
    @expenditure_input_month = Expenditure.where(user_id: @user, updated_at: Time.new(2019,07,01).beginning_of_month..Time.new(2019,07,31).end_of_month).sum(:expenditure_money)
    @material_cost_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,07,01).beginning_of_month..Time.new(2019,07,31).end_of_month).sum(:material_cost)
    @brokerage_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,07,01).beginning_of_month..Time.new(2019,07,31).end_of_month).sum(:brokerage_fee)
    @processing_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,07,01).beginning_of_month..Time.new(2019,07,31).end_of_month).sum(:processing_fee)
    @expenditure_month = @expenditure_input_month + @material_cost_expenditure_month + @brokerage_fee_expenditure_month + @processing_fee_expenditure_month

    @expenditures_rent = Expenditure.where(expenditure_item: "家賃・地代", user_id: @user, updated_at: DateTime.new(2019, 07, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 07, 31, 23, 59, 59).end_of_month)
    @expenditures_utility = Expenditure.where(expenditure_item: "光熱費", user_id: @user, updated_at: DateTime.new(2019, 07, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 07, 31, 23, 59, 59).end_of_month)
    @expenditures_personnel = Expenditure.where(expenditure_item: "人件費", user_id: @user, updated_at: DateTime.new(2019, 07, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 07, 31, 23, 59, 59).end_of_month)
    @expenditures_transport = Expenditure.where(expenditure_item: "交通費", user_id: @user, updated_at: DateTime.new(2019, 07, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 07, 31, 23, 59, 59).end_of_month)
    @expenditures_net = Expenditure.where(expenditure_item: "ネット通信費", user_id: @user, updated_at: DateTime.new(2019, 07, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 07, 31, 23, 59, 59).end_of_month)
    @expenditures_loan = Expenditure.where(expenditure_item: "機械ローン", user_id: @user, updated_at: DateTime.new(2019, 07, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 07, 31, 23, 59, 59).end_of_month)
    @expenditures_otherwise = Expenditure.where(expenditure_item: "その他", user_id: @user, updated_at: DateTime.new(2019, 07, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 07, 31, 23, 59, 59).end_of_month)
    @material_cost = Task.where(user_id: @user, sale_time: DateTime.new(2019, 07, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 07, 31, 23, 59, 59).end_of_month)
    @brokerage_fee = Task.where(user_id: @user, sale_time: DateTime.new(2019, 07, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 07, 31, 23, 59, 59).end_of_month)
    @processing_fee = Task.where(user_id: @user, sale_time: DateTime.new(2019, 07, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 07, 31, 23, 59, 59).end_of_month)
  end

  def expenditure_eight_month
    @user = User.find(current_user[:id])
    @expenditure_input_month = Expenditure.where(user_id: @user, updated_at: Time.new(2019,8,01).beginning_of_month..Time.new(2019,8,31).end_of_month).sum(:expenditure_money)
    @material_cost_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,8,01).beginning_of_month..Time.new(2019,8,31).end_of_month).sum(:material_cost)
    @brokerage_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,8,01).beginning_of_month..Time.new(2019,8,31).end_of_month).sum(:brokerage_fee)
    @processing_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,8,01).beginning_of_month..Time.new(2019,8,31).end_of_month).sum(:processing_fee)
    @expenditure_month = @expenditure_input_month + @material_cost_expenditure_month + @brokerage_fee_expenditure_month + @processing_fee_expenditure_month

    @expenditures_rent = Expenditure.where(expenditure_item: "家賃・地代", user_id: @user, updated_at: DateTime.new(2019, 8, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 8, 31, 23, 59, 59).end_of_month)
    @expenditures_utility = Expenditure.where(expenditure_item: "光熱費", user_id: @user, updated_at: DateTime.new(2019, 8, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 8, 31, 23, 59, 59).end_of_month)
    @expenditures_personnel = Expenditure.where(expenditure_item: "人件費", user_id: @user, updated_at: DateTime.new(2019, 8, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 8, 31, 23, 59, 59).end_of_month)
    @expenditures_transport = Expenditure.where(expenditure_item: "交通費", user_id: @user, updated_at: DateTime.new(2019, 8, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 8, 31, 23, 59, 59).end_of_month)
    @expenditures_net = Expenditure.where(expenditure_item: "ネット通信費", user_id: @user, updated_at: DateTime.new(2019, 8, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 8, 31, 23, 59, 59).end_of_month)
    @expenditures_loan = Expenditure.where(expenditure_item: "機械ローン", user_id: @user, updated_at: DateTime.new(2019, 8, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 8, 31, 23, 59, 59).end_of_month)
    @expenditures_otherwise = Expenditure.where(expenditure_item: "その他", user_id: @user, updated_at: DateTime.new(2019, 8, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 8, 31, 23, 59, 59).end_of_month)
    @material_cost = Task.where(user_id: @user, sale_time: DateTime.new(2019, 8, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 8, 31, 23, 59, 59).end_of_month)
    @brokerage_fee = Task.where(user_id: @user, sale_time: DateTime.new(2019, 8, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 8, 31, 23, 59, 59).end_of_month)
    @processing_fee = Task.where(user_id: @user, sale_time: DateTime.new(2019, 8, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 8, 31, 23, 59, 59).end_of_month)
  end

  def expenditure_nine_month
    @user = User.find(current_user[:id])
    @expenditure_input_month = Expenditure.where(user_id: @user, updated_at: Time.new(2019,9,01).beginning_of_month..Time.new(2019,9,30).end_of_month).sum(:expenditure_money)
    @material_cost_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,9,01).beginning_of_month..Time.new(2019,9,30).end_of_month).sum(:material_cost)
    @brokerage_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,9,01).beginning_of_month..Time.new(2019,9,30).end_of_month).sum(:brokerage_fee)
    @processing_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,9,01).beginning_of_month..Time.new(2019,9,30).end_of_month).sum(:processing_fee)
    @expenditure_month = @expenditure_input_month + @material_cost_expenditure_month + @brokerage_fee_expenditure_month + @processing_fee_expenditure_month

    @expenditures_rent = Expenditure.where(expenditure_item: "家賃・地代", user_id: @user, updated_at: DateTime.new(2019, 9, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 9, 30, 23, 59, 59).end_of_month)
    @expenditures_utility = Expenditure.where(expenditure_item: "光熱費", user_id: @user, updated_at: DateTime.new(2019, 9, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 9, 30, 23, 59, 59).end_of_month)
    @expenditures_personnel = Expenditure.where(expenditure_item: "人件費", user_id: @user, updated_at: DateTime.new(2019, 9, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 9, 30, 23, 59, 59).end_of_month)
    @expenditures_transport = Expenditure.where(expenditure_item: "交通費", user_id: @user, updated_at: DateTime.new(2019, 9, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 9, 30, 23, 59, 59).end_of_month)
    @expenditures_net = Expenditure.where(expenditure_item: "ネット通信費", user_id: @user, updated_at: DateTime.new(2019, 9, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 9, 30, 23, 59, 59).end_of_month)
    @expenditures_loan = Expenditure.where(expenditure_item: "機械ローン", user_id: @user, updated_at: DateTime.new(2019, 9, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 9, 30, 23, 59, 59).end_of_month)
    @expenditures_otherwise = Expenditure.where(expenditure_item: "その他", user_id: @user, updated_at: DateTime.new(2019, 9, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 9, 30, 23, 59, 59).end_of_month)
    @material_cost = Task.where(user_id: @user, sale_time: DateTime.new(2019, 9, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 9, 30, 23, 59, 59).end_of_month)
    @brokerage_fee = Task.where(user_id: @user, sale_time: DateTime.new(2019, 9, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 9, 30, 23, 59, 59).end_of_month)
    @processing_fee = Task.where(user_id: @user, sale_time: DateTime.new(2019, 9, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 9, 30, 23, 59, 59).end_of_month)
  end

  def expenditure_ten_month
    @user = User.find(current_user[:id])
    @expenditure_input_month = Expenditure.where(user_id: @user, updated_at: Time.new(2018,10,01).beginning_of_month..Time.new(2018,10,31).end_of_month).sum(:expenditure_money)
    @material_cost_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2018,10,01).beginning_of_month..Time.new(2018,10,31).end_of_month).sum(:material_cost)
    @brokerage_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2018,10,01).beginning_of_month..Time.new(2018,10,31).end_of_month).sum(:brokerage_fee)
    @processing_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2018,10,01).beginning_of_month..Time.new(2018,10,31).end_of_month).sum(:processing_fee)
    @expenditure_month = @expenditure_input_month + @material_cost_expenditure_month + @brokerage_fee_expenditure_month + @processing_fee_expenditure_month

    @expenditures_rent = Expenditure.where(expenditure_item: "家賃・地代", user_id: @user, updated_at: DateTime.new(2018, 10, 01, 00, 00, 00).beginning_of_month..DateTime.new(2018, 10, 31, 23, 59, 59).end_of_month)
    @expenditures_utility = Expenditure.where(expenditure_item: "光熱費", user_id: @user, updated_at: DateTime.new(2018, 10, 01, 00, 00, 00).beginning_of_month..DateTime.new(2018, 10, 31, 23, 59, 59).end_of_month)
    @expenditures_personnel = Expenditure.where(expenditure_item: "人件費", user_id: @user, updated_at: DateTime.new(2018, 10, 01, 00, 00, 00).beginning_of_month..DateTime.new(2018, 10, 31, 23, 59, 59).end_of_month)
    @expenditures_transport = Expenditure.where(expenditure_item: "交通費", user_id: @user, updated_at: DateTime.new(2018, 10, 01, 00, 00, 00).beginning_of_month..DateTime.new(2018, 10, 31, 23, 59, 59).end_of_month)
    @expenditures_net = Expenditure.where(expenditure_item: "ネット通信費", user_id: @user, updated_at: DateTime.new(2018, 10, 01, 00, 00, 00).beginning_of_month..DateTime.new(2018, 10, 31, 23, 59, 59).end_of_month)
    @expenditures_loan = Expenditure.where(expenditure_item: "機械ローン", user_id: @user, updated_at: DateTime.new(2018, 10, 01, 00, 00, 00).beginning_of_month..DateTime.new(2018, 10, 31, 23, 59, 59).end_of_month)
    @expenditures_otherwise = Expenditure.where(expenditure_item: "その他", user_id: @user, updated_at: DateTime.new(2018, 10, 01, 00, 00, 00).beginning_of_month..DateTime.new(2018, 10, 31, 23, 59, 59).end_of_month)
    @material_cost = Task.where(user_id: @user, sale_time: DateTime.new(2018, 10, 01, 00, 00, 00).beginning_of_month..DateTime.new(2018, 10, 31, 23, 59, 59).end_of_month)
    @brokerage_fee = Task.where(user_id: @user, sale_time: DateTime.new(2018, 10, 01, 00, 00, 00).beginning_of_month..DateTime.new(2018, 10, 31, 23, 59, 59).end_of_month)
    @processing_fee = Task.where(user_id: @user, sale_time: DateTime.new(2018, 10, 01, 00, 00, 00).beginning_of_month..DateTime.new(2018, 10, 31, 23, 59, 59).end_of_month)
  end

  def expenditure_eleven_month
    @user = User.find(current_user[:id])
    @expenditure_input_month = Expenditure.where(user_id: @user, updated_at: Time.new(2018,11,01).beginning_of_month..Time.new(2018,11,30).end_of_month).sum(:expenditure_money)
    @material_cost_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2018,11,01).beginning_of_month..Time.new(2018,11,30).end_of_month).sum(:material_cost)
    @brokerage_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2018,11,01).beginning_of_month..Time.new(2018,11,30).end_of_month).sum(:brokerage_fee)
    @processing_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2018,11,01).beginning_of_month..Time.new(2018,11,30).end_of_month).sum(:processing_fee)
    @expenditure_month = @expenditure_input_month + @material_cost_expenditure_month + @brokerage_fee_expenditure_month + @processing_fee_expenditure_month

    @expenditures_rent = Expenditure.where(expenditure_item: "家賃・地代", user_id: @user, updated_at: DateTime.new(2018, 11, 01, 00, 00, 00).beginning_of_month..DateTime.new(2018, 11, 30, 23, 59, 59).end_of_month)
    @expenditures_utility = Expenditure.where(expenditure_item: "光熱費", user_id: @user, updated_at: DateTime.new(2018, 11, 01, 00, 00, 00).beginning_of_month..DateTime.new(2018, 11, 30, 23, 59, 59).end_of_month)
    @expenditures_personnel = Expenditure.where(expenditure_item: "人件費", user_id: @user, updated_at: DateTime.new(2018, 11, 01, 00, 00, 00).beginning_of_month..DateTime.new(2018, 11, 30, 23, 59, 59).end_of_month)
    @expenditures_transport = Expenditure.where(expenditure_item: "交通費", user_id: @user, updated_at: DateTime.new(2018, 11, 01, 00, 00, 00).beginning_of_month..DateTime.new(2018, 11, 30, 23, 59, 59).end_of_month)
    @expenditures_net = Expenditure.where(expenditure_item: "ネット通信費", user_id: @user, updated_at: DateTime.new(2018, 11, 01, 00, 00, 00).beginning_of_month..DateTime.new(2018, 11, 30, 23, 59, 59).end_of_month)
    @expenditures_loan = Expenditure.where(expenditure_item: "機械ローン", user_id: @user, updated_at: DateTime.new(2018, 11, 01, 00, 00, 00).beginning_of_month..DateTime.new(2018, 11, 30, 23, 59, 59).end_of_month)
    @expenditures_otherwise = Expenditure.where(expenditure_item: "その他", user_id: @user, updated_at: DateTime.new(2018, 11, 01, 00, 00, 00).beginning_of_month..DateTime.new(2018, 11, 30, 23, 59, 59).end_of_month)
    @material_cost = Task.where(user_id: @user, sale_time: DateTime.new(2018, 11, 01, 00, 00, 00).beginning_of_month..DateTime.new(2018, 11, 30, 23, 59, 59).end_of_month)
    @brokerage_fee = Task.where(user_id: @user, sale_time: DateTime.new(2018, 11, 01, 00, 00, 00).beginning_of_month..DateTime.new(2018, 11, 30, 23, 59, 59).end_of_month)
    @processing_fee = Task.where(user_id: @user, sale_time: DateTime.new(2018, 11, 01, 00, 00, 00).beginning_of_month..DateTime.new(2018, 11, 30, 23, 59, 59).end_of_month)
  end

  def expenditure_twelve_month
    @user = User.find(current_user[:id])
    @expenditure_input_month = Expenditure.where(user_id: @user, updated_at: Time.new(2018,12,01).beginning_of_month..Time.new(2018,12,31).end_of_month).sum(:expenditure_money)
    @material_cost_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2018,12,01).beginning_of_month..Time.new(2018,12,31).end_of_month).sum(:material_cost)
    @brokerage_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2018,12,01).beginning_of_month..Time.new(2018,12,31).end_of_month).sum(:brokerage_fee)
    @processing_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2018,12,01).beginning_of_month..Time.new(2018,12,31).end_of_month).sum(:processing_fee)
    @expenditure_month = @expenditure_input_month + @material_cost_expenditure_month + @brokerage_fee_expenditure_month + @processing_fee_expenditure_month

    @expenditures_rent = Expenditure.where(expenditure_item: "家賃・地代", user_id: @user, updated_at: DateTime.new(2018, 12, 01, 00, 00, 00).beginning_of_month..DateTime.new(2018, 12, 31, 23, 59, 59).end_of_month)
    @expenditures_utility = Expenditure.where(expenditure_item: "光熱費", user_id: @user, updated_at: DateTime.new(2018, 12, 01, 00, 00, 00).beginning_of_month..DateTime.new(2018, 12, 31, 23, 59, 59).end_of_month)
    @expenditures_personnel = Expenditure.where(expenditure_item: "人件費", user_id: @user, updated_at: DateTime.new(2018, 12, 01, 00, 00, 00).beginning_of_month..DateTime.new(2018, 12, 31, 23, 59, 59).end_of_month)
    @expenditures_transport = Expenditure.where(expenditure_item: "交通費", user_id: @user, updated_at: DateTime.new(2018, 12, 01, 00, 00, 00).beginning_of_month..DateTime.new(2018, 12, 31, 23, 59, 59).end_of_month)
    @expenditures_net = Expenditure.where(expenditure_item: "ネット通信費", user_id: @user, updated_at: DateTime.new(2018, 12, 01, 00, 00, 00).beginning_of_month..DateTime.new(2018, 12, 31, 23, 59, 59).end_of_month)
    @expenditures_loan = Expenditure.where(expenditure_item: "機械ローン", user_id: @user, updated_at: DateTime.new(2018, 12, 01, 00, 00, 00).beginning_of_month..DateTime.new(2018, 12, 31, 23, 59, 59).end_of_month)
    @expenditures_otherwise = Expenditure.where(expenditure_item: "その他", user_id: @user, updated_at: DateTime.new(2018, 12, 01, 00, 00, 00).beginning_of_month..DateTime.new(2018, 12, 31, 23, 59, 59).end_of_month)
    @material_cost = Task.where(user_id: @user, sale_time: DateTime.new(2018, 12, 01, 00, 00, 00).beginning_of_month..DateTime.new(2018, 12, 31, 23, 59, 59).end_of_month)
    @brokerage_fee = Task.where(user_id: @user, sale_time: DateTime.new(2018, 12, 01, 00, 00, 00).beginning_of_month..DateTime.new(2018, 12, 31, 23, 59, 59).end_of_month)
    @processing_fee = Task.where(user_id: @user, sale_time: DateTime.new(2018, 12, 01, 00, 00, 00).beginning_of_month..DateTime.new(2018, 12, 31, 23, 59, 59).end_of_month)
  end


  #クレジット登録しているか確認
  def no_card?
      @current_user = User.find(current_user[:id])
      if @current_user.customer_id.nil?
        redirect_to "/users/sign_in"
      end
  end


end
