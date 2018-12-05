class RemoveClosingDateFromLists < ActiveRecord::Migration[5.2]
  def change
    remove_column :lists, :closing_date, :datetime
  end
end
