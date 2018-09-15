class TasksController < ApplicationController

before_action :authenticate_user!

  def index
        @login_user = Task.find_by(params[:id])
        @one_week = @login_user.term.to_i - Time.now.to_i
        @time_out = Time.now.to_i - Task.term.to_i
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
    @login_user = Task.find_by_id(params[:id])
    @login_user.update(flag_id: 0)
  end

  def doing
    @login_user = Task.find_by_id(params[:id])
    @login_user.update(flag_id: 0)
  end

  def finish
    @login_user = Task.find_by_id(params[:id])
    @login_user.update(flag_id: 0)
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
    @task = Task.find(params[:id]) #⑤
    if @task.destroy
      render :index #⑥
    end
  end

  private

    def task_params
      params.require(:task).permit(:taskname, :number, :price, :order_number, :term, :picture, :list_id, :user_id)
    end
end