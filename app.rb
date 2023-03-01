require 'sinatra/base'
require 'slack-notifier'
require 'json'
require 'logger'
require 'dotenv/load'
require 'puma'

# Define the route that will receive the POST request
class App < Sinatra::Base
  configure :production do
    # Set up SSL/TLS for secure communication
    set :bind, 'ssl://0.0.0.0:443?key=' + ENV['SSL_KEY'] + '&cert=' + ENV['SSL_CERTIFICATE']
  end

  # Set up a Slack notifier
  notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_URL']

  # Set up a logger
  logger = Logger.new(STDOUT)


  post '/payload' do
    begin
      # Parse the JSON payload
      payload = JSON.parse(request.body.read, :allow_trailing_comma => true)
      # Possible improvement: store the rest of the payload in a database, file or other data store
      # why? Because the payload contains a lot of useful information that can be used to improve your email deliverability.
      # check before implmenting this: Check it's ok to store the data in your country (GDPR, CCPA, etc.)

      # Check if the payload matches the desired criteria
      if payload['Type'] == 'SpamNotification'
        # Send a Slack alert with the email address included in the payload
        message = "New spam report from #{payload['Email']}"
        notifier.ping message
      end
      # possible improvement: do something else if the payload doesn't match the desired criteria

      # Return a 200 OK status code to indicate success
      status 200

    rescue JSON::ParserError => e
      # Handle JSON parsing errors
      logger.error "JSON parsing error: #{e}"
      status 400
      body 'Bad Request'
      # Possible improvement: Log the error or call honeybadger

    rescue StandardError => e
      # Handle all other errors
      logger.error "Error: #{e}"
      status 500
      body 'Internal Server Error'
      # Possible improvement: Log the error or call honeybadger
    end
  end

  # possible improvement: add Basic Authentication to the route
  # protect the route with HTTP Basic Authentication. Code is commented out because it's not needed for this example.
  # Can also have just API keys 
  #use Rack::Auth::Basic, "Protected Area" do |username, password|
  #  username == ENV['USERNAME'] && password == ENV['PASSWORD']
  #end

  # Health check
  get '/health' do
    status 200
    body 'OK'
  end

  # Enable HTTP Strict Transport Security (HSTS) for additional security
  before do
    response.headers['Strict-Transport-Security'] = 'max-age=31536000; includeSubDomains; preload'
  end

  run! if app_file == $0
end
