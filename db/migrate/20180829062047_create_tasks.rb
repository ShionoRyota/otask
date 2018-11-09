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
      t.integer :sale #単価×個数
      t.datetime :sale_time #taskが請求欄に行った時間（この時点で売上に入るため）
      t.integer :list_id
      t.integer :user_id

      t.timestamps
    end
  end
end
