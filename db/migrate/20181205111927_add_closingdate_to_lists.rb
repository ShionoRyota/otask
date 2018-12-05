class AddClosingdateToLists < ActiveRecord::Migration[5.2]
  def change
    add_column :lists, :closingdate, :datetime, default: "2018-01-01 00:00:00"
  end
end
