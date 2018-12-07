class ChangeColumnToExpenditure < ActiveRecord::Migration[5.2]
  def change
    change_column_default :expenditures, :expenditure_money, nil
  end
end
