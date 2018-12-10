class Expenditure < ApplicationRecord
  belongs_to :user

  def expenditure_money=(value)
    value.tr!('０-９', '0-9') if value.is_a?(String)
    super(value)
  end
end
