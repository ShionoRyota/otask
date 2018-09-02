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

      t.timestamps
    end
  end
end
