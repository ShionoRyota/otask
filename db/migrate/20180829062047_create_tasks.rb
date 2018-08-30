class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|

      t.string :taskname
      t.integer :number
      t.integer :price
      t.integer :order_number
      t.integer :list_id
      t.integer :user_id
      t.datetime :term

      t.timestamps
    end
  end
end
