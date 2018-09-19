class TasksController < ApplicationController

before_action :authenticate_user!

  def index
    @task = Task.find_by(list_id: params[:id])
    @one_week = @task.term.to_i - Time.now.to_i
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


  def create
    @list = List.find(params[:list_id])
    @task = @list.tasks.build(task_params)
    @task.user_id = current_user.id
    if @task.save
      render :index
    end
  end


  def destroy
    @task = Task.find(params[:id])
    if @task.destroy
      render :index
    end
  end

  private

    def task_params
      params.require(:task).permit(:taskname, :number, :price, :order_number, :term, :picture, :list_id, :user_id)
    end
end