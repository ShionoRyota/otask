class ExpendituresController < ApplicationController

  def new
    @expenditure = Expenditure.new
  end

  def create
    @expenditure = Expenditure.new(expenditure_params)
    @expenditure.user_id = current_user.id
    if @expenditure.save
    	redirect_to "/users/expenditure"
    end
  end

  private

    def expenditure_params
      params.require(:expenditure).permit(:expenditure_date, :expenditure_item, :expenditure_money, :expenditure_remarks, :user_id)
    end

end
