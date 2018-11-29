module Api::V1
  class ShowGraphController < ApplicationController

    def show
      work_times = select_work_time()
      render json: work_times
    end

    private

    def select_work_time
      user_id = 1111
      params[:id] == 1 ? work_times = WorkTime.where("user_id = #{user_id} and created_at like ") : 
      work_times
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