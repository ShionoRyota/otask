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

<<<<<<< HEAD
  def set_task
    @tmp = Task.find(params[:id])
    @tmp.flag_id += 1
    @tmps = @tmp
    redirect_to tasks_path
=======
  def destroy
    @task = Task.find(params[:id]) #⑤
    if @task.destroy
      render :index #⑥
    end
>>>>>>> 24d133db29d3e3d9c446cfb823d1b7301e0d1753
  end

  private

    def task_params
      params.require(:task).permit(:taskname, :number, :price, :order_number, :term, :picture, :list_id, :user_id)
    end
end