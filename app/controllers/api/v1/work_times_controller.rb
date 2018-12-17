module Api::V1
  class WorkTimesController < ApplicationController

    def index
      user_id = 1111
      
      work_times = aggregate_time(user_id)
      render json: work_times.blank? ? { message: 'データが見つかりません', status: 404 } : work_times
    end

    def create
      work_time = WorkTime.new(work_time_params)
      work_time.time = hour_add_minute()
      work_time.category_id = params[:work_time][:work_time]
      work_time.created_at = created_at
      work_time.updated_at = Time.current
      work_time.user_id = 1111
      work_time.save!
      render json: { message: 'ok', status: 200 }
    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.record.errors, status: 400 }
    end

    def import_work_times
      work_times = []

      calendars_service = CalendarsService.new
      calendar_datas = calendars_service.google_calendar_api(params)

      if Rails.env == 'development' || 'production'
        calendar_datas.each do |calendar_data|
          work_times << WorkTime.new(time: calc_work_time(calendar_data.start.dateTime, calendar_data.end.dateTime),
          category_id: 34, created_at: calendar_data.start.dateTime, updated_at: calendar_data.end.dateTime,
          user_id: 1111)
        end
      end

      if Rails.env == 'test'
        calendar_datas.each do |calendar_data|
          work_times << WorkTime.new(time: calc_work_time(calendar_data[:start][:dateTime], calendar_data[:end][:dateTime]),
          category_id: 34, created_at: calendar_data[:start][:dateTime], updated_at: calendar_data[:end][:dateTime],
          user_id: 1111)
        end
      end
      WorkTime.import work_times
      render json: { message: 'ok',status: 200 }
    end

    private

    #集計し、返す
    def aggregate_time(user_id)
      work_times = params[:type_flag] == 'false' ? calctime(user_id) : calctime_category(user_id)
    end

    #月、日別に計算
    def calctime(user_id)
      work_times = params[:day].nil? ? WorkTime.aggregate_by_title(user_id, change_time(params[:month])) : WorkTime.aggregate_by_title(user_id, "#{change_time(params[:month])}-#{change_time(params[:day])}")
    end

    #カテゴリごとの計算
    def calctime_category(user_id)
      work_times = params[:day].nil? ? WorkTime.aggregate_by_category(user_id, params[:category_id], change_time(params[:month])) : WorkTime.aggregate_by_category(user_id, params[:category_id], "#{change_time(params[:month])}-#{change_time(params[:day])}")
    end

    #1桁のものに０をつける
    def change_time(times)
      return times unless times.to_i <= 9
      "0#{times}"
    end

    #時間と分を足す
    def hour_add_minute
      hour = params[:work_time][:hour].to_i
      minute = (params[:work_time][:minute].to_i / 60.to_f).round(1)
      hour == 0 && minute == 0 ? '' : hour + minute
    end

    def created_at
      d = Date.today
      "#{d.year}-#{params[:work_time][:month]}-#{params[:work_time][:day]}"
    end

    #秒単位を時間単位に変換
    def calc_work_time(startTime, endTime)
      startTime == 0 || endTime == 0 ? '' : (endTime - startTime)/60/60.round(1)
    end

    def work_time_params
      params.require(:work_time).permit(:time, :category_id, :created_at, :updated_at, :user_id)
    end

  end
end
