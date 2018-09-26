class TasksController < ApplicationController

before_action :authenticate_user!
before_action :no_card?


  def index
      @Task = Task.all
      @aa = Task.find_by(params[:id])
      if !@login_user.nil?
            @aa = @login_user.term
            @bb = (@aa - Time.new.to_time)
          if @bb <= 0
               render :red_line
          elsif 0 < @bb && @bb <= 604800
               render :yellow_line
          end
      end

      @suppliers = List.find(params[:list_id])


  end

  def show
      @Task = Task.all

      @suppliers = List.find(params[:list_id])
  end

  def new
    @task = Task.new

  end

  def edit
    @task = Task.find(params[:id])
  end


  def update
    @task = Task.find(params[:id])
    @task.update_attributes(task_params)
    @aa = @task.term
            @bb = (@aa - Time.new.to_time)
          if @bb <= 0
             @task.update(color_id: 2)
          elsif 0 < @bb && @bb <= 604800
             @task.update(color_id: 1)
          else
             @task.update(color_id: 0)
          end
    @sale = (@task.number.to_i * @task.price.to_i)
    if @task.update(sale: @sale)
      redirect_to list_tasks_path
    end

  end

  def todo
    @login_user = Task.find(params[:id])
    @aa = @login_user.term
            @bb = (@aa - Time.new.to_time)
          if @bb <= 0
             @login_user.update(flag_id: 0, color_id: 2)
          elsif 0 < @bb && @bb <= 604800
             @login_user.update(flag_id: 0, color_id: 1)
          else
             @login_user.update(flag_id: 0, color_id: 0)
          end
    @login_user.update(sale_time: "NULL")
    redirect_back(fallback_location: list_tasks_path)
  end

  def doing
    @login_user = Task.find(params[:id])
    @aa = @login_user.term
            @bb = (@aa - Time.new.to_time)
          if @bb <= 0
             @login_user.update(flag_id: 1, color_id: 2)
          elsif 0 < @bb && @bb <= 604800
             @login_user.update(flag_id: 1, color_id: 1)
          else
             @login_user.update(flag_id: 1, color_id: 0)
          end
    @login_user.update(sale_time: "NULL")
    redirect_back(fallback_location: list_tasks_path)
  end

  def finish
    @login_user = Task.find(params[:id])
    @aa = @login_user.term
            @bb = (@aa - Time.new.to_time)
          if @bb <= 0
             @login_user.update(flag_id: 2, color_id: 2)
          elsif 0 < @bb && @bb <= 604800
             @login_user.update(flag_id: 2, color_id: 1)
          else
             @login_user.update(flag_id: 2, color_id: 0)
          end
    @login_user.update(sale_time: "NULL")
    redirect_back(fallback_location: list_tasks_path)
  end

  def sale
    @login_user = Task.find(params[:id])
    @login_user.update(flag_id: 3, sale_time: Time.now)
    redirect_back(fallback_location: list_tasks_path)
  end



  def create
    @list = List.find(params[:list_id]) #①
    @task = @list.tasks.build(task_params) #②
    @task.user_id = current_user.id
    @aa = @task.term
            @bb = (@aa - Time.new.to_time)
          if @bb <= 0
               @task.color_id = 2
          elsif 0 < @bb && @bb <= 604800
               @task.color_id = 1
          else
               @task.color_id = 0
          end
      @sale = (@task.number.to_i * @task.price.to_i)
    if @task.update(sale: @sale)
      render :index #④
    end
  end

  def destroy
    @list = List.find(params[:list_id]) #①
    @task = Task.find(params[:id]) #⑤
    @task.destroy
    redirect_to list_tasks_path #④
  end

  def no_card?
      @current_user = User.find(current_user[:id])
      if @current_user.customer_id.nil?
        redirect_to users_show_path
      end
  end


  def invoice
    @suppliers = List.find(params[:list_id])
    @company = User.find(current_user[:id])
    @total = Task.where(flag_id: 3).sum(:sale)
    @tax = (@total.to_i * 0.08).round
    @sum = (@total + @tax)
  end

  def delnote
    @suppliers = List.find(params[:list_id])
    @company = User.find(current_user[:id])
    @total = Task.where(flag_id: 3).sum(:sale)
    @tax = (@total.to_i * 0.08).round
    @sum = (@total + @tax)
  end

  def ahead
    @suppliers = List.find(params[:list_id])
    @company = User.find(current_user[:id])
    @total = Task.where(flag_id: 3).sum(:sale)
    @tax = (@total.to_i * 0.08).round
    @sum = (@total + @tax)
  end

  def task_clear
    @login_user = Task.find(params[:id])
    @login_user.update(flag_id: 4)
    redirect_back(fallback_location: list_tasks_path)
  end

  private

    def task_params
      params.require(:task).permit(:taskname, :number, :price, :order_number, :term, :picture, :list_id, :user_id)
    end
end