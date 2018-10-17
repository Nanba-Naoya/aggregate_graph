class WorkTime < ApplicationRecord
  belongs_to :category
  validates :time, presence: true
end