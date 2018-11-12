class CreateExpenditures < ActiveRecord::Migration[5.2]
  def change
    create_table :expenditures do |t|

      t.datetime :expenditure_date # 日付
      t.string :expenditure_item # 項目
      t.integer :expenditure_money # 金額
      t.string :expenditure_remarks # 備考
      t.integer :user_id
      t.timestamps
    end
  end
end
