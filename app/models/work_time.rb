class WorkTime < ApplicationRecord
  belongs_to :category, optional: true
  validates :time, presence: true
end