class AddClosingDateToLists < ActiveRecord::Migration[5.2]
  def change
    add_column :lists, :closing_date, :datetime
  end
end
