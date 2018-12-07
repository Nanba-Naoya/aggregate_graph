require 'google/api_client'

module Api::V1
  class GetGoogleCalendarsController < ApplicationController
    include ActionController::Cookies

    def index
      token = `curl -d client_id=1062349073075-3l06qo9t1huckd0d58mr1g6n3h9tpgbm.apps.googleusercontent.com -d client_secret=T1g-7nU2bbYg5WUOgDh_Fm5e -d redirect_uri=http://localhost:4200 -d grant_type=authorization_code -d code=#{params[:query]} https://accounts.google.com/o/oauth2/token`
      token = JSON.parse(token)
      client = Google::APIClient.new(application_name: '')
      client.authorization.client_id = ENV['CLIENT_ID']
      client.authorization.client_secret = ENV['CLIENT_SECRET']
      client.authorization.scope = ENV['SCOPE']
      client.authorization.access_token = token['access_token']
      cal = client.discovered_api('calendar', 'v3')

      time_min = Time.utc(2018, 12, 5, 00, 00, 00).iso8601
      time_max = Time.utc(2018, 12, 12, 23, 59, 59).iso8601
      
      params = { 'calendarId' => 'primary',
        'orderBy' => 'startTime',
        'timeMax' => time_max,
        'timeMin' => time_min,
        'singleEvents' => 'True' }

      result = client.execute(api_method: cal.events.list, parameters: params)
      events = result.data.items

      events.each do |event|
        work_time = WorkTime.new
        work_time.time = ((event.end.dateTime - event.start.dateTime)/60/60).round(1)
        work_time.category_id = 34
        work_time.created_at = event.start.dateTime
        work_time.updated_at = event.end.dateTime
        work_time.user_id = 1111
        #work_time.save!
      end
    end
  end
end