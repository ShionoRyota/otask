class Task < ApplicationRecord

  belongs_to :user, foreign_key: "user_id", optional: true
  belongs_to :list, foreign_key: "list_id", optional: true
  mount_uploader :picture, PictureUploader
end
