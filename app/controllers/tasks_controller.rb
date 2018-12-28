class TasksController < ApplicationController

before_action :authenticate_user! # ログイン済ユーザーのみにアクセスを許可する
before_action :no_card? # クレカ登録してるか確認(課金者以外排除)

# task表示画面
  def index
    @Task = Task.all # viewで表示されるtaskを限定
    @list = current_user.lists.find(params[:list_id]) # 右上list名表示
    @invoice_sale = Task.where(list_id: @list, flag_id: 3).sum(:sale)
  #   @user = User.find(current_user[:id])
  #   @task = Task.where(user_id: @user, sale_time: Time.zone.now.all_day).sum(:sale)
  #   @user.update(sales: @task)
  end

# 請求済みの仕事のtaskの表示
  def show
    @Task = Task.all # viewで表示されるtaskを限定
    @suppliers = current_user.lists.find(params[:list_id])
  end

# task作成
  def new
    @task = Task.new
    # 3.times { @task.thumbnails.build } # 写真投稿フォーム3つ（要検討）
    @task.thumbnails.build
  end

# task作成
  def create
    @list = current_user.lists.find(params[:list_id])
    @task = @list.tasks.build(task_params)
    @task.user_id = current_user.id
  # taskのsaleを計算
    @sale = (@task.number.to_i * @task.price.to_i)
    if @task.update(sale: @sale)
  # 色変化
    @aa = @task.term
    @bb = (@aa - Time.new.to_time)
      if @bb <= 0
        @task.update(color_id: 2)
      elsif 0 < @bb && @bb <= 604800
        @task.update(color_id: 1)
      else
        @task.update(color_id: 0)
      end
        redirect_to list_tasks_path
    else
      @task = @list.tasks.new(task_params)
      render :new
    end
  end

# task編集
  def edit
    @task = current_user.tasks.find(params[:id])
    # 0.times { @task.thumbnails.build } # task登録時の写真の数だけのフォームに（要検討）
    if @task.thumbnails.empty?
      @task.thumbnails.build
    end
  end

  # editで画像押すと拡大
  def download
    @task = current_user.tasks.find(params[:id])
  end


# editの内容に変更
  def update
    @task = current_user.tasks.find(params[:id])
    @task.update_attributes(task_params)
    # taskのsaleを計算
    @sale = (@task.number.to_i * @task.price.to_i)
    if @task.update(sale: @sale)
  # 色変化
    @aa = @task.term
    @bb = (@aa - Time.new.to_time)
      if @bb <= 0
        @task.update(color_id: 2)
      elsif 0 < @bb && @bb <= 604800
        @task.update(color_id: 1)
      else
        @task.update(color_id: 0)
      end
        redirect_to list_tasks_path
    else
      render :edit
    end
  end

# 削除ボタン
  def destroy
    @task = current_user.tasks.find(params[:id])
    @task.destroy
    redirect_to list_tasks_path
  end


# TODOボタン
  def todo
    @login_user = current_user.tasks.find(params[:id])
    @login_user.update(flag_id: 0, sale_time: "NULL")
    redirect_back(fallback_location: list_tasks_path)
  end

# 作業中ボタン
  def doing
    @login_user = current_user.tasks.find(params[:id])
    @login_user.update(flag_id: 1, sale_time: "NULL")
    redirect_back(fallback_location: list_tasks_path)
  end

# 完了ボタン
  def finish
    @login_user = current_user.tasks.find(params[:id])
    @login_user.update(flag_id: 2, sale_time: Time.now)
    redirect_back(fallback_location: list_tasks_path)
  end

# 請求ボタン
  def sale
    @login_user = current_user.tasks.find(params[:id])
    @login_user.update(flag_id: 3)
    redirect_back(fallback_location: list_tasks_path)
  end

  # 履歴に残すボタン
  def task_clear
    @login_user = current_user.tasks.find(params[:id])
    @login_user.update(flag_id: 4)
    redirect_back(fallback_location: list_tasks_path)
  end

# 請求書作成画面へボタン
def invoice
  @suppliers = current_user.lists.find(params[:list_id])
  @company = User.find(current_user[:id])
  @list = current_user.lists.find(params[:list_id]) # 右上list名表示
    @total = Task.where(list_id: @list, flag_id: 3).sum(:sale) #index請求欄のtaskのみ表示
    @tax = (@total.to_i * 0.08).round #小数点以下四捨五入
    @sum = (@total + @tax)
  end

# 納品書作成画面へボタン
def delnote
  @suppliers = current_user.lists.find(params[:list_id])
  @company = User.find(current_user[:id])
  @list = current_user.lists.find(params[:list_id]) # 右上list名表示
    @total = Task.where(list_id: @list, flag_id: 3).sum(:sale) #index請求欄のtaskのみ表示
    @tax = (@total.to_i * 0.08).round #小数点以下四捨五入
    @sum = (@total + @tax)
  end

# 控え作成画面へボタン
def ahead
  @suppliers = current_user.lists.find(params[:list_id])
  @company = User.find(current_user[:id])
  @list = current_user.lists.find(params[:list_id]) # 右上list名表示
    @total = Task.where(list_id: @list, flag_id: 3).sum(:sale) #index請求欄のtaskのみ表示
    @tax = (@total.to_i * 0.08).round #小数点以下四捨五入
    @sum = (@total + @tax)
  end

#クレジット登録しているか確認
  def no_card?
      @current_user = User.find(current_user[:id])
      if @current_user.customer_id.nil?
        redirect_to users_show_path
      end
  end

# 売上履歴（できれば一つにまとめたい）
  def sale_detail
    @user = User.find(current_user[:id])
    @list = current_user.lists.find(params[:list_id])
  if params[:type] == '1'
    @tasks = Task.where(list_id: @list, user_id: @user, sale_time: DateTime.new(2019, 1, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 1, 31, 23, 59, 59).end_of_month)
  elsif params[:type] == '2'
    @tasks = Task.where(list_id: @list, user_id: @user, sale_time: DateTime.new(2019, 2, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 2, 28, 23, 59, 59).end_of_month)
  elsif params[:type] == '3'
    @tasks = Task.where(list_id: @list, user_id: @user, sale_time: DateTime.new(2019, 3, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 3, 31, 23, 59, 59).end_of_month)
  elsif params[:type] == '4'
    @tasks = Task.where(list_id: @list, user_id: @user, sale_time: DateTime.new(2019, 4, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 4, 30, 23, 59, 59).end_of_month)
  elsif params[:type] == '5'
    @tasks = Task.where(list_id: @list, user_id: @user, sale_time: DateTime.new(2019, 5, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 5, 31, 23, 59, 59).end_of_month)
  elsif params[:type] == '6'
    @tasks = Task.where(list_id: @list, user_id: @user, sale_time: DateTime.new(2019, 6, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 6, 30, 23, 59, 59).end_of_month)
  elsif params[:type] == '7'
    @tasks = Task.where(list_id: @list, user_id: @user, sale_time: DateTime.new(2019, 7, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 7, 31, 23, 59, 59).end_of_month)
  elsif params[:type] == '8'
    @tasks = Task.where(list_id: @list, user_id: @user, sale_time: DateTime.new(2019, 8, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 8, 31, 23, 59, 59).end_of_month)
  elsif params[:type] == '9'
    @tasks = Task.where(list_id: @list, user_id: @user, sale_time: DateTime.new(2019, 9, 01, 00, 00, 00).beginning_of_month..DateTime.new(2019, 9, 30, 23, 59, 59).end_of_month)
  elsif params[:type] == '10'
    @tasks = Task.where(list_id: @list, user_id: @user, sale_time: DateTime.new(2018, 10, 01, 00, 00, 00).beginning_of_month..DateTime.new(2018, 10, 31, 23, 59, 59).end_of_month)
  elsif params[:type] == '11'
    @tasks = Task.where(list_id: @list, user_id: @user, sale_time: DateTime.new(2018, 11, 01, 00, 00, 00).beginning_of_month..DateTime.new(2018, 11, 30, 23, 59, 59).end_of_month)
  elsif params[:type] == '12'
    @tasks = Task.where(list_id: @list, user_id: @user, sale_time: DateTime.new(2018, 12, 01, 00, 00, 00).beginning_of_month..DateTime.new(2018, 12, 31, 23, 59, 59).end_of_month)
  end
  end

  def search
    @tasks = Task.where(user_id: current_user[:id]).search(params[:search]).includes(:list)
  end

  private

    def task_params
      params.require(:task).permit(:taskname, :number, :price, :order_number, :term, :remarks, :material_cost, :brokerage_fee, :processing_fee, :duration, :list_id, :user_id, :image, :memo)
    end
end
