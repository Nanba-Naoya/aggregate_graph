class WorkTime < ApplicationRecord
  belongs_to :category, optional: true
  validates :time, presence: true

  scope :of_search, ->(user_id, date) { joins(:category).where("work_times.user_id = #{user_id} and work_times.created_at LIKE ?", "2018-#{date}%")}
  
  class << self
    def aggregate_by_title(user_id, date)
      of_search(user_id, date).group(:title).sum(:time)
    end

    def aggregate_by_category(user_id, category_id, date)
      of_search(user_id, date).where(category_id: category_id).group(:title).sum(:time)
    end
  end

end