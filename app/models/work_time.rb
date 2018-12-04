class WorkTime < ApplicationRecord
  belongs_to :category, optional: true
  validates :time, presence: true

  scope :of_work_time, ->(user_id, date) { where("user_id = #{user_id} and created_at LIKE ?", "2018-#{date}%")}
  scope :of_category_time, ->(user_id, category_id, date) { where("user_id = #{user_id} and category_id = #{category_id} and created_at LIKE ?", "2018-#{date}%")}
  
end