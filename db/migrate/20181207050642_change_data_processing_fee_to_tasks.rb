class ChangeDataProcessingFeeToTasks < ActiveRecord::Migration[5.2]
  def change
  change_column :tasks, :processing_fee, :string
  end
end
