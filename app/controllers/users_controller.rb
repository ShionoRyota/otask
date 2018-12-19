class UsersController < ApplicationController
	# protect_from_forgery except: :pay #payのCSRF対策が無効
  before_action :authenticate_user!, except: [:delete_done]
  before_action :no_card?, except: [:show, :pay, :delete_done] # show,pay,delete_done以外はクレカ登録してるか確認(課金者以外排除)

# ホーム画面
def index
end

# user登録の記入内容確認画面
def show
  @user = User.find(current_user[:id])
end

# pay.jpと連携
def pay
 Payjp.api_key = ENV['PAY_ID']

 customer = Payjp::Customer.create(
  description: 'OTask本番環境サービス利用者'
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
  Payjp.api_key = ENV['PAY_ID']
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
  @expenditure_day = @expenditure_input_day.to_i + @material_cost_expenditure_day.to_i + @brokerage_fee_expenditure_day.to_i + @processing_fee_expenditure_day.to_i

  @expenditure_input_month = Expenditure.where(user_id: @user, updated_at: Time.zone.now.all_month).sum(:expenditure_money)
  @material_cost_expenditure_month = Task.where(user_id: @user, sale_time: Time.zone.now.all_month).sum(:material_cost)
  @brokerage_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.zone.now.all_month).sum(:brokerage_fee)
  @processing_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.zone.now.all_month).sum(:processing_fee)
  @expenditure_month = @expenditure_input_month.to_i + @material_cost_expenditure_month.to_i + @brokerage_fee_expenditure_month.to_i + @processing_fee_expenditure_month.to_i

  @expenditure_input_year = Expenditure.where(user_id: @user, updated_at: Time.zone.now.all_year).sum(:expenditure_money)
  @material_cost_expenditure_year = Task.where(user_id: @user, sale_time: Time.zone.now.all_year).sum(:material_cost)
  @brokerage_fee_expenditure_year = Task.where(user_id: @user, sale_time: Time.zone.now.all_year).sum(:brokerage_fee)
  @processing_fee_expenditure_year = Task.where(user_id: @user, sale_time: Time.zone.now.all_year).sum(:processing_fee)
  @expenditure_year = @expenditure_input_year.to_i + @material_cost_expenditure_year.to_i + @brokerage_fee_expenditure_year.to_i + @processing_fee_expenditure_year.to_i

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

  #クレジット登録しているか確認
  def no_card?
    @current_user = User.find(current_user[:id])
    if @current_user.customer_id.nil?
      redirect_to "/users/sign_in"
    end
  end

  #請求みの仕事で本日の履歴か全部の履歴かを選択する画面
  def billed
  end

  def billed_today
    @user = User.find(current_user[:id])
    @lists = current_user.lists.all #自分のlistのみ全て表示
  end


# 売上履歴（できれば一つにまとめたい）
def expenditure_months
  if params[:type] == '1'
    @user = User.find(current_user[:id])
    @expenditure_input_month = Expenditure.where(user_id: @user, updated_at: Time.new(2019,01,01).beginning_of_month..Time.new(2019,01,31).end_of_month).sum(:expenditure_money)
    @material_cost_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,01,01).beginning_of_month..Time.new(2019,01,31).end_of_month).sum(:material_cost)
    @brokerage_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,01,01).beginning_of_month..Time.new(2019,01,31).end_of_month).sum(:brokerage_fee)
    @processing_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,01,01).beginning_of_month..Time.new(2019,01,31).end_of_month).sum(:processing_fee)
    @expenditure_month = @expenditure_input_month.to_i + @material_cost_expenditure_month.to_i + @brokerage_fee_expenditure_month.to_i + @processing_fee_expenditure_month.to_i

    @month = 1
    @expenditures = Expenditure.where(user_id: @user, updated_at: DateTime.new(2019, 01, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 01, 31, 23, 59, 59).end_of_month)
    @task_expenditure = Task.where(user_id: @user, create_at: DateTime.new(2019, 01, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 01, 31, 23, 59, 59).end_of_month)

  elsif params[:type] == '2'
    @user = User.find(current_user[:id])
    @expenditure_input_month = Expenditure.where(user_id: @user, updated_at: Time.new(2019,02,01).beginning_of_month..Time.new(2019,02,28).end_of_month).sum(:expenditure_money)
    @material_cost_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,02,01).beginning_of_month..Time.new(2019,02,28).end_of_month).sum(:material_cost)
    @brokerage_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,02,01).beginning_of_month..Time.new(2019,02,28).end_of_month).sum(:brokerage_fee)
    @processing_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,02,01).beginning_of_month..Time.new(2019,02,28).end_of_month).sum(:processing_fee)
    @expenditure_month = @expenditure_input_month.to_i + @material_cost_expenditure_month.to_i + @brokerage_fee_expenditure_month.to_i + @processing_fee_expenditure_month.to_i

    @month = 2
    @expenditures = Expenditure.where(user_id: @user, updated_at: DateTime.new(2019, 02, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 02, 28, 23, 59, 59).end_of_month)
    @task_expenditure = Task.where(user_id: @user, sale_time: DateTime.new(2019, 02, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 02, 28, 23, 59, 59).end_of_month)

  elsif params[:type] == '3'
    @user = User.find(current_user[:id])
    @expenditure_input_month = Expenditure.where(user_id: @user, updated_at: Time.new(2019,03,01).beginning_of_month..Time.new(2019,03,31).end_of_month).sum(:expenditure_money)
    @material_cost_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,03,01).beginning_of_month..Time.new(2019,03,31).end_of_month).sum(:material_cost)
    @brokerage_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,03,01).beginning_of_month..Time.new(2019,03,31).end_of_month).sum(:brokerage_fee)
    @processing_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,03,01).beginning_of_month..Time.new(2019,03,31).end_of_month).sum(:processing_fee)
    @expenditure_month = @expenditure_input_month.to_i + @material_cost_expenditure_month.to_i + @brokerage_fee_expenditure_month.to_i + @processing_fee_expenditure_month.to_i

    @month = 3
    @expenditures = Expenditure.where(user_id: @user, updated_at: DateTime.new(2019, 03, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 03, 31, 23, 59, 59).end_of_month)
    @task_expenditure = Task.where(user_id: @user, sale_time: DateTime.new(2019, 03, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 03, 31, 23, 59, 59).end_of_month)

  elsif params[:type] == '4'
    @user = User.find(current_user[:id])
    @expenditure_input_month = Expenditure.where(user_id: @user, updated_at: Time.new(2019,04,01).beginning_of_month..Time.new(2019,04,30).end_of_month).sum(:expenditure_money)
    @material_cost_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,04,01).beginning_of_month..Time.new(2019,04,30).end_of_month).sum(:material_cost)
    @brokerage_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,04,01).beginning_of_month..Time.new(2019,04,30).end_of_month).sum(:brokerage_fee)
    @processing_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,04,01).beginning_of_month..Time.new(2019,04,30).end_of_month).sum(:processing_fee)
    @expenditure_month = @expenditure_input_month.to_i + @material_cost_expenditure_month.to_i + @brokerage_fee_expenditure_month.to_i + @processing_fee_expenditure_month.to_i

    @month = 4
    @expenditures = Expenditure.where(user_id: @user, updated_at: DateTime.new(2019, 04, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 04, 30, 23, 59, 59).end_of_month)
    @task_expenditure = Task.where(user_id: @user, sale_time: DateTime.new(2019, 04, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 04, 30, 23, 59, 59).end_of_month)

  elsif params[:type] == '5'
    @user = User.find(current_user[:id])
    @expenditure_input_month = Expenditure.where(user_id: @user, updated_at: Time.new(2019,05,01).beginning_of_month..Time.new(2019,05,31).end_of_month).sum(:expenditure_money)
    @material_cost_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,05,01).beginning_of_month..Time.new(2019,05,31).end_of_month).sum(:material_cost)
    @brokerage_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,05,01).beginning_of_month..Time.new(2019,05,31).end_of_month).sum(:brokerage_fee)
    @processing_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,05,01).beginning_of_month..Time.new(2019,05,31).end_of_month).sum(:processing_fee)
    @expenditure_month = @expenditure_input_month.to_i + @material_cost_expenditure_month.to_i + @brokerage_fee_expenditure_month.to_i + @processing_fee_expenditure_month.to_i

    @month = 5
    @expenditures = Expenditure.where(user_id: @user, updated_at: DateTime.new(2019, 05, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 05, 31, 23, 59, 59).end_of_month)
    @task_expenditure = Task.where(user_id: @user, sale_time: DateTime.new(2019, 05, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 05, 31, 23, 59, 59).end_of_month)

  elsif params[:type] == '6'
    @user = User.find(current_user[:id])
    @expenditure_input_month = Expenditure.where(user_id: @user, updated_at: Time.new(2019,06,01).beginning_of_month..Time.new(2019,06,30).end_of_month).sum(:expenditure_money)
    @material_cost_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,06,01).beginning_of_month..Time.new(2019,06,30).end_of_month).sum(:material_cost)
    @brokerage_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,06,01).beginning_of_month..Time.new(2019,06,30).end_of_month).sum(:brokerage_fee)
    @processing_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,06,01).beginning_of_month..Time.new(2019,06,30).end_of_month).sum(:processing_fee)
    @expenditure_month = @expenditure_input_month.to_i + @material_cost_expenditure_month.to_i + @brokerage_fee_expenditure_month.to_i + @processing_fee_expenditure_month.to_i

    @month = 6
    @expenditures = Expenditure.where(user_id: @user, updated_at: DateTime.new(2019, 06, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 06, 30, 23, 59, 59).end_of_month)
    @task_expenditure = Task.where(user_id: @user, sale_time: DateTime.new(2019, 06, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 06, 30, 23, 59, 59).end_of_month)

  elsif params[:type] == '7'
    @user = User.find(current_user[:id])
    @expenditure_input_month = Expenditure.where(user_id: @user, updated_at: Time.new(2019,07,01).beginning_of_month..Time.new(2019,07,31).end_of_month).sum(:expenditure_money)
    @material_cost_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,07,01).beginning_of_month..Time.new(2019,07,31).end_of_month).sum(:material_cost)
    @brokerage_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,07,01).beginning_of_month..Time.new(2019,07,31).end_of_month).sum(:brokerage_fee)
    @processing_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,07,01).beginning_of_month..Time.new(2019,07,31).end_of_month).sum(:processing_fee)
    @expenditure_month = @expenditure_input_month.to_i + @material_cost_expenditure_month.to_i + @brokerage_fee_expenditure_month.to_i + @processing_fee_expenditure_month.to_i

    @month = 7
    @expenditures = Expenditure.where(user_id: @user, updated_at: DateTime.new(2019, 07, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 07, 31, 23, 59, 59).end_of_month)
    @task_expenditure = Task.where(user_id: @user, sale_time: DateTime.new(2019, 07, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 07, 31, 23, 59, 59).end_of_month)

  elsif params[:type] == '8'
    @user = User.find(current_user[:id])
    @expenditure_input_month = Expenditure.where(user_id: @user, updated_at: Time.new(2019,8,01).beginning_of_month..Time.new(2019,8,31).end_of_month).sum(:expenditure_money)
    @material_cost_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,8,01).beginning_of_month..Time.new(2019,8,31).end_of_month).sum(:material_cost)
    @brokerage_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,8,01).beginning_of_month..Time.new(2019,8,31).end_of_month).sum(:brokerage_fee)
    @processing_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,8,01).beginning_of_month..Time.new(2019,8,31).end_of_month).sum(:processing_fee)
    @expenditure_month = @expenditure_input_month.to_i + @material_cost_expenditure_month.to_i + @brokerage_fee_expenditure_month.to_i + @processing_fee_expenditure_month.to_i

    @month = 8
    @expenditures = Expenditure.where(user_id: @user, updated_at: DateTime.new(2019, 8, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 8, 31, 23, 59, 59).end_of_month)
    @task_expenditure = Task.where(user_id: @user, sale_time: DateTime.new(2019, 8, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 8, 31, 23, 59, 59).end_of_month)

  elsif params[:type] == '9'
    @user = User.find(current_user[:id])
    @expenditure_input_month = Expenditure.where(user_id: @user, updated_at: Time.new(2019,9,01).beginning_of_month..Time.new(2019,9,30).end_of_month).sum(:expenditure_money)
    @material_cost_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,9,01).beginning_of_month..Time.new(2019,9,30).end_of_month).sum(:material_cost)
    @brokerage_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,9,01).beginning_of_month..Time.new(2019,9,30).end_of_month).sum(:brokerage_fee)
    @processing_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2019,9,01).beginning_of_month..Time.new(2019,9,30).end_of_month).sum(:processing_fee)
    @expenditure_month = @expenditure_input_month.to_i + @material_cost_expenditure_month.to_i + @brokerage_fee_expenditure_month.to_i + @processing_fee_expenditure_month.to_i

    @month = 9
    @expenditures = Expenditure.where(user_id: @user, updated_at: DateTime.new(2019, 9, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 9, 30, 23, 59, 59).end_of_month)
    @task_expenditure = Task.where(user_id: @user, sale_time: DateTime.new(2019, 9, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 9, 30, 23, 59, 59).end_of_month)

  elsif params[:type] == '10'
    @user = User.find(current_user[:id])
    @expenditure_input_month = Expenditure.where(user_id: @user, updated_at: Time.new(2018,10,01).beginning_of_month..Time.new(2018,10,31).end_of_month).sum(:expenditure_money)
    @material_cost_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2018,10,01).beginning_of_month..Time.new(2018,10,31).end_of_month).sum(:material_cost)
    @brokerage_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2018,10,01).beginning_of_month..Time.new(2018,10,31).end_of_month).sum(:brokerage_fee)
    @processing_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2018,10,01).beginning_of_month..Time.new(2018,10,31).end_of_month).sum(:processing_fee)
    @expenditure_month = @expenditure_input_month.to_i + @material_cost_expenditure_month.to_i + @brokerage_fee_expenditure_month.to_i + @processing_fee_expenditure_month.to_i

    @month = 10
    @expenditures = Expenditure.where(user_id: @user, updated_at: DateTime.new(2018, 10, 01, 00, 00, 00).beginning_of_month..DateTime.new(2018, 10, 31, 23, 59, 59).end_of_month)
    @task_expenditure = Task.where(user_id: @user, sale_time: DateTime.new(2018, 10, 01, 00, 00, 00).beginning_of_month..DateTime.new(2018, 10, 31, 23, 59, 59).end_of_month)

  elsif params[:type] == '11'
    @user = User.find(current_user[:id])
    @expenditure_input_month = Expenditure.where(user_id: @user, updated_at: Time.new(2018,11,01).beginning_of_month..Time.new(2018,11,30).end_of_month).sum(:expenditure_money)
    @material_cost_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2018,11,01).beginning_of_month..Time.new(2018,11,30).end_of_month).sum(:material_cost)
    @brokerage_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2018,11,01).beginning_of_month..Time.new(2018,11,30).end_of_month).sum(:brokerage_fee)
    @processing_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2018,11,01).beginning_of_month..Time.new(2018,11,30).end_of_month).sum(:processing_fee)
    @expenditure_month = @expenditure_input_month.to_i + @material_cost_expenditure_month.to_i + @brokerage_fee_expenditure_month.to_i + @processing_fee_expenditure_month.to_i

    @month = 11
    @expenditures = Expenditure.where(user_id: @user, updated_at: DateTime.new(2018, 11, 01, 00, 00, 00).beginning_of_month..DateTime.new(2018, 11, 30, 23, 59, 59).end_of_month)
    @task_expenditure = Task.where(user_id: @user, sale_time: DateTime.new(2018, 11, 01, 00, 00, 00).beginning_of_month..DateTime.new(2018, 11, 30, 23, 59, 59).end_of_month)

  elsif params[:type] == '12'
    @user = User.find(current_user[:id])
    @expenditure_input_month = Expenditure.where(user_id: @user, updated_at: Time.new(2018,12,01).beginning_of_month..Time.new(2018,12,31).end_of_month).sum(:expenditure_money)
    @material_cost_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2018,12,01).beginning_of_month..Time.new(2018,12,31).end_of_month).sum(:material_cost)
    @brokerage_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2018,12,01).beginning_of_month..Time.new(2018,12,31).end_of_month).sum(:brokerage_fee)
    @processing_fee_expenditure_month = Task.where(user_id: @user, sale_time: Time.new(2018,12,01).beginning_of_month..Time.new(2018,12,31).end_of_month).sum(:processing_fee)
    @expenditure_month = @expenditure_input_month.to_i + @material_cost_expenditure_month.to_i + @brokerage_fee_expenditure_month.to_i + @processing_fee_expenditure_month.to_i

    @month = 12
    @expenditures = Expenditure.where(user_id: @user, updated_at: DateTime.new(2018, 12, 01, 00, 00, 00).beginning_of_month..DateTime.new(2018, 12, 31, 23, 59, 59).end_of_month)
    @task_expenditure = Task.where(user_id: @user, sale_time: DateTime.new(2018, 12, 01, 00, 00, 00).beginning_of_month..DateTime.new(2018, 12, 31, 23, 59, 59).end_of_month)
  end
end

end
