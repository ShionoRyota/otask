class Task < ApplicationRecord

  belongs_to :user
  belongs_to :list
  has_many :thumbnails, dependent: :destroy

  accepts_nested_attributes_for :thumbnails

  mount_uploader :image, ThumbnailUploader

end
