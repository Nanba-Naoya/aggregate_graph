require 'google/api_client'
require 'time'
require 'webrick'
require 'json'

# Initialize OAuth 2.0 client
# authorization
a = `curl -d client_id=1062349073075-3l06qo9t1huckd0d58mr1g6n3h9tpgbm.apps.googleusercontent.com -d client_secret=T1g-7nU2bbYg5WUOgDh_Fm5e -d refresh_token=1/ZHrXRMu8UUlAwSmRWncGh1mrqpX5qM0B02bgz-Z7qd0 -d grant_type=refresh_token  https://www.googleapis.com/oauth2/v3/token`
token = JSON.parse(a)
client = Google::APIClient.new(application_name: '')
client.authorization.client_id = ENV['CLIENT_ID']
client.authorization.client_secret = ENV['CLIENT_SECRET']
client.authorization.scope = ENV['SCOPE']
client.authorization.refresh_token = ENV['REFRESH_TOKEN']
client.authorization.access_token = token['access_token']

cal = client.discovered_api('calendar', 'v3')

# comfirm the time from user
printf('カレンダーを表示する年(20XX)：')
year = gets.strip.to_i
printf('カレンダーを表示する月(1-12)：')
month = gets.strip.to_i
printf('カレンダーを表示する日(1-31)：')
day = gets.strip.to_i

# place the time from user
time_min = Time.utc(year, month, 1, 00, 00, 00).iso8601
time_max = Time.utc(year, month, 31, 23, 59, 59).iso8601

# get the event
params = { 'calendarId' => 'naoyamessi10@gmail.com',
           'orderBy' => 'startTime',
           'timeMax' => time_max,
           'timeMin' => time_min,
           'singleEvents' => 'True' }

result = client.execute(api_method: cal.events.list,
                        parameters: params)
# place the event
events = result.data.items

# puts
events.each do |event|
  puts event.summary
  #puts event.description
  #puts event.location
  #puts event.htmlLink
  #puts event.etag
  #puts (event.end.dateTime - event.start.dateTime)/60/60
  #puts '*****：' + event.creator['email']
  #event.attendees.each do |aaa|
  #  unless aaa['email'] == event.creator['email'] || aaa['responseStatus'] == 'declined'
  #  puts aaa['email']
  #  end
  #end
end