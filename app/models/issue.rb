class Issue < ApplicationRecord
  validates :name, presence: true
  belongs_to :repository
  # soft_delete
  # scope :not_deleted, -> { where(soft_deleted: false) }
  # scope :deleted, -> { where(soft_deleted: true) }
end
