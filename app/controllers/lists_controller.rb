class ListsController < ApplicationController

  before_action :authenticate_user! #ログイン済ユーザーのみにアクセスを許可する
  before_action :no_card? #クレカ登録してるか確認(課金者以外排除)

#list表示画面
  def index
    @list = List.new
    @lists = current_user.lists.all #自分のlistのみ全て表示
    # @user = User.find(current_user[:id])
    # @task = Task.where(user_id: @user, sale_time: Time.zone.now.all_day).sum(:sale)
    # @user.update(sales: @task)
  end

#list作成
	def create
    @list = List.new(list_params)
    @list.user = current_user
    @list.save
    redirect_to lists_path
  end

#listの内容変更
  def edit
    @list = current_user.lists.find(params[:id])
  end

#editの内容に変更
  def update
    @list = current_user.lists.find(params[:id])
    @list.update_attributes(list_params)
    redirect_to lists_path
  end

#リスト削除
  def destroy
    @list = current_user.lists.find(params[:id])
    if @list.destroy
      redirect_to lists_path
    end
  end

#クレジット登録しているか確認
  def no_card?
      @current_user = User.find(current_user[:id])
      if @current_user.customer_id.nil?  #登録していなければ登録画面へ
        redirect_to users_show_path
      end
  end

#請求済みの仕事のlistを表示
  def show
    @lists = current_user.lists.all
  end

# 売上履歴（できれば一つにまとめたい）
def sale_months
  @user = User.find(current_user[:id])
  @lists = current_user.lists.all
  if params[:type] == '1'
    @task = Task.where(user_id: @user, sale_time: Time.new(2019,01,01).beginning_of_month..Time.new(2019,01,31).end_of_month).sum(:sale)
    @month = 1
  elsif params[:type] == '2'
    @task = Task.where(user_id: @user, sale_time: Time.new(2019,02,01).beginning_of_month..Time.new(2019,02,28).end_of_month).sum(:sale)
    @month = 2
  elsif params[:type] == '3'
    @task = Task.where(user_id: @user, sale_time: Time.new(2019,03,01).beginning_of_month..Time.new(2019,03,31).end_of_month).sum(:sale)
    @month = 3
  elsif params[:type] == '4'
    @task = Task.where(user_id: @user, sale_time: Time.new(2019,04,01).beginning_of_month..Time.new(2019,04,30).end_of_month).sum(:sale)
    @month = 4
  elsif params[:type] == '5'
    @task = Task.where(user_id: @user, sale_time: Time.new(2019,05,01).beginning_of_month..Time.new(2019,05,31).end_of_month).sum(:sale)
    @month = 5
  elsif params[:type] == '6'
    @task = Task.where(user_id: @user, sale_time: Time.new(2019,06,01).beginning_of_month..Time.new(2019,06,30).end_of_month).sum(:sale)
    @month = 6
  elsif params[:type] == '7'
    @task = Task.where(user_id: @user, sale_time: Time.new(2019,07,01).beginning_of_month..Time.new(2019,07,31).end_of_month).sum(:sale)
    @month = 7
  elsif params[:type] == '8'
    @task = Task.where(user_id: @user, sale_time: Time.new(2019,8,01).beginning_of_month..Time.new(2019,8,31).end_of_month).sum(:sale)
    @month = 8
  elsif params[:type] == '9'
    @task = Task.where(user_id: @user, sale_time: Time.new(2018,9,01).beginning_of_month..Time.new(2018,9,30).end_of_month).sum(:sale)
    @month = 9
  elsif params[:type] == '10'
    @task = Task.where(user_id: @user, sale_time: Time.new(2018,10,01).beginning_of_month..Time.new(2018,10,31).end_of_month).sum(:sale)
    @month = 10
  elsif params[:type] == '11'
    @task = Task.where(user_id: @user, sale_time: Time.new(2018,11,01).beginning_of_month..Time.new(2018,11,30).end_of_month).sum(:sale)
    @month = 11
  elsif params[:type] == '12'
    @task = Task.where(user_id: @user, sale_time: Time.new(2018,12,01).beginning_of_month..Time.new(2018,12,31).end_of_month).sum(:sale)
    @month = 12
  end
end




  private

    def list_params
      params.require(:list).permit(:name, :user_id, :customers_postal_code, :customers_address, :customers_phone_number, :customers_fax_number, :closingdate)
    end
end
