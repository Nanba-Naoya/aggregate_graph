module Api::V1
  class WorkTimesController < ApplicationController

    def index
      @work_times = WorkTime.all
      render json: @work_times
    end

    def show
      @work_times = WorkTime.all
      render json: @work_times
    end

    def create
      work_times = WorkTime.new(work_time_params)
      work_times.time = calctime()
      work_times.times_category_id = params[:work_time][:work_time]
      work_times.created_at = Time.current
      work_times.updated_at = Time.current
      work_times.user_id = 1111
      work_times.save!
    end

    private

    def work_time_params
      params.require(:work_time).permit(:time, :times_category_id, :created_at, :updated_at, :user_id)
    end

    def calctime
      hour = params[:work_time][:hour]
      minute = params[:work_time][:minute]
      work_time = "#{hour}時間#{minute}分"
      work_time
    end

  end
end