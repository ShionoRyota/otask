class ListsController < ApplicationController

  before_action :authenticate_user!

  def index
    @list = List.new
    @lists = current_user.lists.all
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

  private

    def list_params
      params.require(:list).permit(:name, :user_id)
    end
end
