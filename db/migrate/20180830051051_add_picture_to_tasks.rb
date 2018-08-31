class AddPictureToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :picture, :string
  end
end
