class List < ApplicationRecord

  belongs_to :user, optional: true
  has_many :tasks, dependent: :destroy


  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
end
