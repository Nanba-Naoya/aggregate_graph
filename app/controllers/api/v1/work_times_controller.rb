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
      work_times.category_id = params[:work_time][:work_time]
      work_times.created_at = created_at()
      work_times.updated_at = Time.current
      work_times.user_id = 1111
      work_times.save!
    end

    private

    def work_time_params
      params.require(:work_time).permit(:time, :category_id, :created_at, :updated_at, :user_id)
    end

    def calctime
      hour = params[:work_time][:hour].to_i
      minute = (params[:work_time][:minute].to_i / 60.to_f).round(1)
      work_time = hour + minute
      work_time
    end

    def created_at
      d = Date.today
      created_at = "#{d.year}-#{params[:work_time][:month]}-#{params[:work_time][:day]}"
      created_at
    end

  end
end