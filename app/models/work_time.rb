class WorkTime < ApplicationRecord
  belongs_to :category, optional: true
  validates :time, presence: true

  scope :calc_category, ->(user_id, category_id, date) { where("user_id = #{user_id} and category_id = #{category_id} and created_at LIKE ?", "2018-#{date}%").sum(:time)}
  scope :of_calc, ->(user_id, date) { where("user_id = #{user_id} and created_at LIKE ?", "2018-#{date}%").group(:category_id).sum(:time)}
  
end