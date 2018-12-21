class Category < ApplicationRecord
  belongs_to :work_time, optional: true
  validates :title, presence: true
  accepts_nested_attributes_for :work_time

  scope :search_title, ->(title, user_id) { where(title: title, user_id: user_id)}
end