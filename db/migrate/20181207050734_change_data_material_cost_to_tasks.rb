class ChangeDataMaterialCostToTasks < ActiveRecord::Migration[5.2]
  def change
  change_column :tasks, :material_cost, :string
  end
end
