class Category < ApplicationRecord
  belongs_to :work_time
  validates :name, presence: true
end