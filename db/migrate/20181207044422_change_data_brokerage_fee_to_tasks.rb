class ChangeDataBrokerageFeeToTasks < ActiveRecord::Migration[5.2]
  def change
  change_column :tasks, :brokerage_fee, :string
  end
end
