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
      category_names = []
      work_times = {}

      work_datas = params[:day].nil? ? WorkTime.of_calc(user_id, change_time(params[:month])) : WorkTime.of_calc(user_id, "#{change_time(params[:month])}-#{change_time(params[:day])}")
      category_names = Category.of_name(work_datas.keys)
      #hashに変換
      work_times = [category_names, work_datas.values].transpose
      work_times = Hash[*work_times.flatten]
      work_times
    end

    def calctime_category(user_id)
      work_times = {}

      work_datas = params[:day].nil? ? WorkTime.calc_category(user_id, params[:category_id], change_time(params[:month])) : WorkTime.calc_category(user_id, params[:category_id], "#{change_time(params[:month])}-#{change_time(params[:day])}")
      category_name = Category.find(params[:category_id])
      work_times["#{category_name['title']}"] = work_datas
      work_times
    end

    def change_time(times)
      return times unless times.to_i <= 9
      "0#{times}"
    end

  end
end