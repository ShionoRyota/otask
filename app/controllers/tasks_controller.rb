class TasksController < ApplicationController

before_action :authenticate_user!
before_action :no_card?


  def index
    @Task = Task.all
    if !@login_user = Task.find_by_id(params[:id]).nil?
      @one_week = @login_user.term.to_i - Time.now.to_i
      @time_out = Time.now.to_i - @login_user.term.to_i
    end
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
    redirect_to list_tasks_path

  end

  def todo
    @task = Task.find(params[:id])
    @task.update(flag_id: 0)
    redirect_back(fallback_location: list_tasks_path)
  end

  def doing
    @login_user = Task.find(params[:id])
    @login_user.update(flag_id: 1)
    redirect_back(fallback_location: list_tasks_path)
  end

  def finish
    @login_user = Task.find(params[:id])
    @login_user.update(flag_id: 2)
    redirect_back(fallback_location: list_tasks_path)
  end




  def create
    @list = List.find(params[:list_id]) #①
    @task = @list.tasks.build(task_params) #②
    @task.user_id = current_user.id #③
    if @task.save
      render :index #④
    end
  end

  def destroy
    @list = List.find(params[:list_id]) #①
    @task = Task.find(params[:id]) #⑤
    @task.destroy
    render :index #④
  end

  def no_card?
      @current_user = User.find(current_user[:id])
      if @current_user.customer_id.nil?
        redirect_to users_show_path
      end
  end

  private

    def task_params
      params.require(:task).permit(:taskname, :number, :price, :order_number, :term, :picture, :list_id, :user_id)
    end
end