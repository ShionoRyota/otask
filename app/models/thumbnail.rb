class Thumbnail < ApplicationRecord
  belongs_to :task

  mount_uploader :images, ThumbnailUploader
end
