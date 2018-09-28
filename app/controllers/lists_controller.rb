class ListsController < ApplicationController

  before_action :authenticate_user!
  before_action :no_card?


  def index
    @list = List.new
    @lists = current_user.lists.all

    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.zone.now.all_day).sum(:sale)
    @user.update(sales: @task)
  end

  def edit
    @list = List.find(params[:id])
  end


	def create
    @list = List.new(list_params)
    @list.user = current_user
    if @list.save!
      redirect_to :lists
    end
  end

  def update
    @list = List.find(params[:id])
    @list.update_attributes(list_params)
    redirect_to lists_path
  end

  def destroy
    @list = List.find(params[:id])
    if @list.destroy
      redirect_to lists_path
    end
  end

  def no_card?
      @current_user = User.find(current_user[:id])
      if @current_user.customer_id.nil?
        redirect_to users_show_path
      end
  end

  def show
    @lists = current_user.lists.all

    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user,sale_time: Time.zone.now.all_day).sum(:sale)
    @user.update(sales: @task)
  end

  def one_month
    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.new(2018,01,01).beginning_of_month..Time.new(2018,01,31).end_of_month).sum(:sale)
  end

  def two_month
    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.new(2018,02,01).beginning_of_month..Time.new(2018,02,28).end_of_month).sum(:sale)
  end

  def three_month
    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.new(2018,03,01).beginning_of_month..Time.new(2018,03,31).end_of_month).sum(:sale)
  end

  def four_month
    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.new(2018,04,01).beginning_of_month..Time.new(2018,04,30).end_of_month).sum(:sale)
  end

  def five_month
    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.new(2018,05,01).beginning_of_month..Time.new(2018,05,31).end_of_month).sum(:sale)
  end

  def six_month
    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.new(2018,06,01).beginning_of_month..Time.new(2018,06,30).end_of_month).sum(:sale)
  end

  def seven_month
    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.new(2018,07,01).beginning_of_month..Time.new(2018,07,31).end_of_month).sum(:sale)
  end

  def eight_month
    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.new(2018,8,01).beginning_of_month..Time.new(2018,8,31).end_of_month).sum(:sale)
  end

  def nine_month
    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.new(2018,9,01).beginning_of_month..Time.new(2018,9,30).end_of_month).sum(:sale)
  end

  def ten_month
    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.new(2018,10,01).beginning_of_month..Time.new(2018,10,31).end_of_month).sum(:sale)
  end

  def eleven_month
    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.new(2018,11,01).beginning_of_month..Time.new(2018,11,30).end_of_month).sum(:sale)
  end

  def twelve_month
    @user = User.find(current_user[:id])
    @task = Task.where(user_id: @user, sale_time: Time.new(2018,12,01).beginning_of_month..Time.new(2018,12,31).end_of_month).sum(:sale)
  end



  private

    def list_params
      params.require(:list).permit(:name, :user_id)
    end
end
