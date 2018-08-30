class Task < ApplicationRecord

  belongs_to :list, optional: true
  belongs_to :user, optional: true
  mount_uploader :picture, PictureUploader

end
