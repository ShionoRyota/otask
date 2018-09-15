class TasksController < ApplicationController

before_action :authenticate_user!

  def index
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