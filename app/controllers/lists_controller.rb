class ListsController < ApplicationController

  before_action :authenticate_user!

  def index
    @list = List.new
    @lists = current_user.lists.all
  end


	def create
    @list = List.new(list_params)
    @list.user = current_user
    if @list.save!
      redirect_to :lists
    else
      render :action => 'index'
    end
  end

  def destroy
  end

  private

    def list_params
      params.require(:list).permit(:name, :user_id)
    end
end
