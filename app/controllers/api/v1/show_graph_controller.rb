module Api::V1
  class ShowGraphController < ApplicationController

    def index
      work_times = select_work_time
      work_times['error'] = true if work_times.empty?
      render json: work_times
    end

    private

    def select_work_time
      user_id = 1111

      work_times = params[:type_flag] == 'false' ? calctime(user_id) : calctime_category(user_id)
      work_times
    end

    def calctime(user_id)
      work_times = params[:day].nil? ? WorkTime.aggregate_by_title(user_id, change_time(params[:month])) : WorkTime.aggregate_by_title(user_id, "#{change_time(params[:month])}-#{change_time(params[:day])}")
    end

    def calctime_category(user_id)
      work_times = params[:day].nil? ? WorkTime.aggregate_by_category(user_id, params[:category_id], change_time(params[:month])) : WorkTime.aggregate_by_category(user_id, params[:category_id], "#{change_time(params[:month])}-#{change_time(params[:day])}")
    end

    def change_time(times)
      return times unless times.to_i <= 9
      "0#{times}"
    end

  end
end