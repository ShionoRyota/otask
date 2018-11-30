class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|

      t.string :taskname # 仕事名
      t.string :number # 個数
      t.string :price # 単価
      t.string :order_number # 注文番号
      t.datetime :term # 納期
      t.string :remarks # 備考
      t.integer :flag_id, default: 0 # taskの進歩状況
      t.integer :color_id, default: 0 # 納期が迫ることによる色
      t.integer :sale , default: 0#単価×個数
      t.integer :material_cost, default: 0 #材料代
      t.integer :brokerage_fee, default: 0 #仲介料
      t.integer :processing_fee, default: 0 #加工代
      t.string :duration #作業の所要時間
      t.datetime :sale_time #taskが請求欄に行った時間（この時点で売上に入るため）
      t.integer :list_id
      t.integer :user_id
      t.string :image

      t.timestamps
    end
  end
end
