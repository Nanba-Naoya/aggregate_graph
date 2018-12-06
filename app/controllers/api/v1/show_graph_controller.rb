module Api::V1
  class ShowGraphController < ApplicationController

    def index
      work_times = select_work_time
      if work_times.empty?
        work_times['error'] = true;
      end
      render json: work_times
    end

    private

    def select_work_time
      user_id = 1111

      params[:type_flag] == 'false' ? work_times = calctime(user_id) : work_times = calctime_category(user_id)
      work_times
    end

    def calctime(user_id)
      category_ids = []
      work_times = {}

      params[:day].nil? ? work_dates = WorkTime.of_work_time(user_id, change_time(params[:month])) : work_dates = WorkTime.of_work_time(user_id, "#{change_time(params[:month])}-#{change_time(params[:day])}")

      work_dates.each do |work_date|
        category_ids.include?(work_date['category_id']) ?  category_ids << work_date['category_id'] : category_ids << work_date['category_id']
        category_name = Category.find(work_date['category_id'])
        category_ids.include?(work_date['category_id']) ? work_times["#{category_name['title']}"] = work_times["#{category_name['title']}"].to_f + work_date['time'].to_f : work_times["#{category_name['title']}"] = work_date['time'].to_f
      end
      work_times
    end

    def calctime_category(user_id)
      work_times = {}

      params[:day].nil? ? work_dates = WorkTime.of_category_time(user_id, params[:category_id], change_time(params[:month])) : work_dates = WorkTime.of_category_time(user_id, params[:category_id], "#{change_time(params[:month])}-#{change_time(params[:day])}")
      
      work_dates.each do |work_date|
        category_name = Category.find(work_date['category_id'])
        work_times["#{category_name['title']}"] = work_times["#{category_name['title']}"].to_f + work_date['time'].to_f
      end
      work_times
    end

    def change_time(times)
      times = "0#{times}" if times.to_i <= 9
      times
    end

  end
end