class AddCustomersPostalCodeToLists < ActiveRecord::Migration[5.2]
  def change
    add_column :lists, :customers_postal_code, :string  # 郵便番号
    add_column :lists, :customers_address, :string      # 住所
    add_column :lists, :customers_phone_number, :string # 電話番号
    add_column :lists, :customers_fax_number, :string   # FAX番号
  end
end
