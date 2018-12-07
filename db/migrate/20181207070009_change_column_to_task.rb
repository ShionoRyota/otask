class ChangeColumnToTask < ActiveRecord::Migration[5.2]
  def change
    change_column_default :tasks, :material_cost, nil
    change_column_default :tasks, :brokerage_fee, nil
    change_column_default :tasks, :processing_fee, nil

  end
end
