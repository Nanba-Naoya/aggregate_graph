require 'google/api_client'

class CalendarsService
  
  def google_calendar_api(params)
    access_token = create_token(params)
    client = Google::APIClient.new(application_name: '')
    client.authorization.client_id = ENV['CLIENT_ID']
    client.authorization.client_secret = ENV['CLIENT_SECRET']
    client.authorization.scope = ENV['SCOPE']
    client.authorization.access_token = access_token
    calendar = client.discovered_api('calendar', 'v3')

    time_min = Time.utc(2018, 12, 5, 00, 00, 00).iso8601
    time_max = Time.utc(2018, 12, 12, 23, 59, 59).iso8601
    
    params = { 'calendarId' => 'primary',
      'orderBy' => 'startTime',
      'timeMax' => time_max,
      'timeMin' => time_min,
      'singleEvents' => 'True' }

    #google_apiを叩く
    calendar_result = client.execute(api_method: calendar.events.list, parameters: params)
    calendar_result.data.items
  end

  def create_token(params)
    url = 'https://accounts.google.com/o/oauth2/token'
    uri = URI.parse(url)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    oauth_request = Net::HTTP::Post.new(uri.request_uri)
    oauth_request["Content-Type"] = "application/json"
    oauth_request_params = {code: params[:query], grant_type: 'authorization_code',
      redirect_uri: 'http://localhost:4200', client_secret: ENV['CLIENT_SECRET'], client_id: ENV['CLIENT_ID']}
    oauth_request.body = oauth_request_params.to_json
    oauth_response = https.request(oauth_request)
    response = JSON.parse(oauth_response.body)
    response['access_token']
  end

end
