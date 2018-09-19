class Task < ApplicationRecord

  belongs_to :user
  belongs_to :list
  mount_uploader :picture, PictureUploader
end
