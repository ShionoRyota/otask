class List < ApplicationRecord

  belongs_to :user
  has_many :tasks, dependent: :destroy


  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :name, presence: true

  def customers_postal_code=(value)
    value.tr!('/[０-９ー]/', '/[0-9-]/') if value.is_a?(String)
    super(value)
  end

  def customers_phone_number=(value)
    value.tr!('/[０-９ー]/', '/[0-9-]/') if value.is_a?(String)
    super(value)
  end

  def customers_fax_number=(value)
    value.tr!('/[０-９ー]/', '/[0-9-]/') if value.is_a?(String)
    super(value)
  end

end
