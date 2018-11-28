class Category < ApplicationRecord
  belongs_to :work_time, optional: true
  validates :title, presence: true
  accepts_nested_attributes_for :work_time
end