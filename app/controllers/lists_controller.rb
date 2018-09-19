class ListsController < ApplicationController

  before_action :authenticate_user!
  before_action :no_card?


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

  def no_card?
      @current_user = User.find(current_user[:id])
      if @current_user.customer_id.nil?
        redirect_to users_show_path
      end
  end

  private

    def list_params
      params.require(:list).permit(:name, :user_id)
    end
end
