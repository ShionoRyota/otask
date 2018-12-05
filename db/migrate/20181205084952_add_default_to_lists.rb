class AddDefaultToLists < ActiveRecord::Migration[5.2]
  def change
  	change_column_default :lists, :closing_date, default: DateTime.now
  end
end
