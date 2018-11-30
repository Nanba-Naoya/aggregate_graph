module Api::V1
  class ShowGraphController < ApplicationController

    def show
      work_times = select_work_time()
      render json: work_times
    end

    private

    def select_work_time
      user_id = 1111
      params[:id] == "1" ? work_times = WorkTime.where("user_id = #{user_id} and created_at like '2018-11%'") : work_times = 'NG'
      work_data = calctime(work_times)
      work_data
    end

    def calctime(work_times)
      #work_data = Hash.new { |hash, key| hash[key] = [] }
      category = {}
      work_data = []

      work_times.each do |work_time|
        if category.include?("#{work_time['times_category_id']}")
        end
        category["#{work_time['times_category_id']}"] = work_time['time']
        work_data = work_time
      end
      work_data
    end



    def category_month_work_time(work_times)
      work_times = WorkTime.where("times_category_id = ")
    end

    def category_week_work_time()
    end

    def category_day_work_time(work_times)
    end

  end
end