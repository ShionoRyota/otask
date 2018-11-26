class ExpendituresController < ApplicationController

  before_action :authenticate_user! #ログイン済ユーザーのみにアクセスを許可する
  before_action :no_card? #クレカ登録してるか確認(課金者以外排除)


  def new
    @expenditure = Expenditure.new
  end

  def create
    @expenditure = Expenditure.new(expenditure_params)
    @expenditure.user_id = current_user.id
    @expenditure.save
    redirect_to  users_expenditure_path
  end

  #クレジット登録しているか確認
  def no_card?
      @current_user = User.find(current_user[:id])
      if @current_user.customer_id.nil?  #登録していなければ登録画面へ
        redirect_to users_show_path
      end
  end

  private

    def expenditure_params
      params.require(:expenditure).permit(:expenditure_date, :expenditure_item, :expenditure_money, :expenditure_remarks, :user_id)
    end

end
