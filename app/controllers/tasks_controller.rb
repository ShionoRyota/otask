class TasksController < ApplicationController

before_action :authenticate_user!

  def index
    @tasks = current_user.tasks.all
  end

  def new
    @task = Task.new
    @tasks = current_user.tasks.all
  end

  def edit
    @task = Task.find(params[:id])
  end


  def create
    @task = Task.new(task_params)
    @task.user = current_user
    if @task.save!
      redirect_to :tasks
    else
      render :action => 'index'
    end
  end

  def update
    @task = Task.find(params[:id])
    @task.update_attributes(task_params)
    redirect_to tasks_path
  end


  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_path
  end

  private

    def task_params
      params.require(:task).permit(:taskname, :number, :price, :order_number, :term, :picture, :list_id, :user_id)
    end
end