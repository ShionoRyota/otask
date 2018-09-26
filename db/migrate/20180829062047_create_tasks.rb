class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|

      t.string :taskname
      t.string :number
      t.string :price
      t.string :order_number
      t.integer :list_id
      t.integer :user_id
      t.datetime :term
      t.integer :flag_id, default: 0
      t.integer :color_id, default: 0
      t.integer :sale
      t.string :remarks
      t.datetime :sale_time

      t.timestamps
    end
  end
end
