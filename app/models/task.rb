class Task < ApplicationRecord

  belongs_to :user
  belongs_to :list
  has_many :thumbnails, dependent: :destroy

  accepts_nested_attributes_for :thumbnails

  mount_uploader :image, ThumbnailUploader

  validates :taskname, presence: true

  def price=(value)
    value.tr!('０-９', '0-9') if value.is_a?(String)
    super(value)
  end

  def number=(value)
    value.tr!('０-９', '0-9') if value.is_a?(String)
    super(value)
  end

  def material_cost=(value)
    value.tr!('０-９', '0-9') if value.is_a?(String)
    super(value)
  end

  def brokerage_fee=(value)
    value.tr!('０-９', '0-9') if value.is_a?(String)
    super(value)
  end

  def processing_fee=(value)
    value.tr!('０-９', '0-9') if value.is_a?(String)
    super(value)
  end

end
