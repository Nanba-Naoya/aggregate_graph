module Api::V1
  class WorkTimesController < ApplicationController
    SEARCH_WORD = '個人作業'.freeze
    FIRST_CATEGORY =  '会議'.freeze

    def index
      work_times = aggregate_time(params[:user_id])
      render json: work_times.blank? ? { message: I18n.t('record_not_found'), status: 404 } : work_times
    end

    def create
      work_time = WorkTime.new(time: hour_add_minute, category_id: params[:category_id], created_at: created_at,
                              user_id: params[:user_id])
      work_time.save!
      render json: { message: I18n.t('create_work_time_message'), status: 200 }
    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.record.errors.full_messages, status: 400 }
    end

    def create_access_token
      calendars_service = GoogleApi::CalendarsService.new
      new_id = calendars_service.create_new_id(params)
      render json: { message: I18n.t('create_user_id'), status: 200, user_id: new_id}
    end

    def import
      calendars_service = GoogleApi::CalendarsService.new
      access_token = calendars_service.refresh_token(params[:user_id])
      calendar_datas = calendars_service.calendar_data(access_token)
      category_id = check_category_id
      import_self_work_time(import_calendar_datas(calendar_datas, category_id))
      render json: { message: I18n.t('seach_google_calendar'), status: 200 , cookie: params[:user_id]}
    rescue => e
      render json: { message: e, status: 500}
    end

    private

    def import_calendar_datas(calendar_datas, category_id)
      work_times = []
      calendar_data_self = []

      calendar_datas.each do |calendar_data|
        # カレンダーのデータに終日と本文がない場合はスキップ
        next if !(calendar_data.start.date.nil?) || calendar_data.description.nil?
        start_time = calendar_data.start.dateTime
        end_time = calendar_data.end.dateTime
        next if WorkTime.search_same_data(calc_work_time(start_time, end_time), start_time, params[:user_id]).present?
        # 「個人作業」が含まれていなかったら会議として保存
        calendar_data_self << calendar_data unless decision_include_search_word(calendar_data)
        work_times << work_time = WorkTime.new(time: calc_work_time(start_time, end_time), category_id: category_id,
                                               created_at: start_time, updated_at: end_time, user_id: params[:user_id])
      end
      WorkTime.import work_times
      calendar_data_self
    end

    def decision_include_search_word(calendar_data)
      return true if (calendar_data.summary.include?(SEARCH_WORD) == false && calendar_data.description.include?(SEARCH_WORD) == false)
    end

    # 個人作業」が含まれていた場合は新しいカテゴリとして保存し、業務時間を保存、user_listを保存
    def import_self_work_time(calendar_datas)
      self_work_time = []
      attendees = []

      calendar_datas.each do |calendar_data|
        start_time = calendar_data.start.dateTime
        end_time = calendar_data.end.dateTime
        category = Category.find_or_initialize_by(title: calendar_data.summary, user_id: params[:user_id])
        category.save! if category.new_record?
        @new_category_id = Category.search_id(calendar_data.summary, params[:user_id])[0]
        self_work_time << WorkTime.new(time: calc_work_time(start_time, end_time), category_id: @new_category_id,
                                       created_at: start_time, updated_at: end_time,user_id: params[:user_id])
        next if calendar_data.attendees.blank?
        attendees << calendar_data.attendees
      end
      WorkTime.import self_work_time
      import_attendees(attendees)
    end

    def import_attendees(attendees)
      users_lists = []

      attendees.each do |attendee|
        # 自分以外を保存、/@/ =~ attendee['email'] -> @を探して@以前を抽出
        next if (attendee['email'] == calendar_data.creator['email']) == true || (attendee['responseStatus'] == 'declined') == true
        /@/ =~ attendee['email']
        work_time_id = WorkTime.where(category_id: @new_category_id, created_at: calendar_data.start.dateTime, user_id: params[:user_id])[0][:id]
        users_lists << WorkUsersList.new(user_name: $`,work_time_id: work_time_id, user_id: params[:user_id])
      end
      WorkUsersList.import users_lists
    end

    def check_category_id
      Category.search_id(FIRST_CATEGORY, params[:user_id])[0]
    end

    # 業務時間を集計し、返す
    def aggregate_time(user_id)
      work_times = params[:type_flag] == 'false' ? calctime(user_id) : calctime_category(user_id)
    end

    # 月、日別に業務時間を計算
    def calctime(user_id)
      params[:day] = nil if params[:day] == 'null'
      work_times = params[:day].nil? ? WorkTime.aggregate_by_title(user_id, change_time(params[:month])) : WorkTime.aggregate_by_title(user_id, "#{change_time(params[:month])}-#{change_time(params[:day])}")
    end

    # カテゴリごとに月、日別で業務時間を計算
    def calctime_category(user_id)
      work_times = params[:day].nil? ? WorkTime.aggregate_by_category(user_id, params[:category_id], change_time(params[:month])) : WorkTime.aggregate_by_category(user_id, params[:category_id], "#{change_time(params[:month])}-#{change_time(params[:day])}")
    end

    # 1桁のものに０をつける
    def change_time(times)
      return times unless times.to_i <= 9
      "0#{times}"
    end

    # 時間と分を足す
    def hour_add_minute
      hour = params[:hour].to_i
      minute = (params[:minute].to_i / 60.to_f).round(1)
      hour == 0 && minute == 0 ? '' : hour + minute
    end

    def created_at
      d = Date.today
      "#{d.year}-#{params[:month]}-#{params[:day]}"
    end

    # 秒単位を時間単位に変換
    def calc_work_time(startTime, endTime)
      startTime == 0 || endTime == 0 ? '' : (endTime - startTime)/60/60.round(1)
    end

    def work_time_params
      params.require(:work_time).permit(:category_id)
    end

  end
end
