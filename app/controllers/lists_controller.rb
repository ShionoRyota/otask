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
    @list = List.find(params[:id])
  end

#editの内容に変更
  def update
    @list = List.find(params[:id])
    @list.update_attributes(list_params)
    redirect_to lists_path
  end

#リスト削除
  def destroy
    @list = List.find(params[:id])
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
  def one_month
    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.new(2019,01,01).beginning_of_month..Time.new(2019,01,31).end_of_month).sum(:sale)
    @lists = current_user.lists.all
  end

  def two_month
    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.new(2019,02,01).beginning_of_month..Time.new(2019,02,28).end_of_month).sum(:sale)
    @lists = current_user.lists.all
  end

  def three_month
    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.new(2019,03,01).beginning_of_month..Time.new(2019,03,31).end_of_month).sum(:sale)
    @lists = current_user.lists.all
  end

  def four_month
    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.new(2019,04,01).beginning_of_month..Time.new(2019,04,30).end_of_month).sum(:sale)
    @lists = current_user.lists.all
  end

  def five_month
    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.new(2019,05,01).beginning_of_month..Time.new(2019,05,31).end_of_month).sum(:sale)
    @lists = current_user.lists.all
  end

  def six_month
    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.new(2019,06,01).beginning_of_month..Time.new(2019,06,30).end_of_month).sum(:sale)
    @lists = current_user.lists.all
  end

  def seven_month
    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.new(2019,07,01).beginning_of_month..Time.new(2019,07,31).end_of_month).sum(:sale)
    @lists = current_user.lists.all
  end

  def eight_month
    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.new(2019,8,01).beginning_of_month..Time.new(2019,8,31).end_of_month).sum(:sale)
    @lists = current_user.lists.all
  end

  def nine_month
    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.new(2018,9,01).beginning_of_month..Time.new(2018,9,30).end_of_month).sum(:sale)
    @lists = current_user.lists.all
  end

  def ten_month
    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.new(2018,10,01).beginning_of_month..Time.new(2018,10,31).end_of_month).sum(:sale)
    @lists = current_user.lists.all
  end

  def eleven_month
    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.new(2018,11,01).beginning_of_month..Time.new(2018,11,30).end_of_month).sum(:sale)
    @lists = current_user.lists.all
  end

  def twelve_month
    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.new(2018,12,01).beginning_of_month..Time.new(2018,12,31).end_of_month).sum(:sale)
    @lists = current_user.lists.all
  end




  private

    def list_params
      params.require(:list).permit(:name, :user_id)
    end
end
