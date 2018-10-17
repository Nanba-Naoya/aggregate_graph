class Category < ApplicationRecord
  belongs_to :time
  validates :name, presence: true
end