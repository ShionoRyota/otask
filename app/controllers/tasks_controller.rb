class TasksController < ApplicationController

before_action :authenticate_user!

  def show
    @task = Task.new
    @tasks = current_user.tasks.all
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


  def destroy
  end

  private

    def task_params
      params.require(:task).permit(:taskname, :list_id, :user_id)
    end
end