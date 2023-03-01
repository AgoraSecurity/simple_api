require 'sinatra'
require 'slack-notifier'
require 'json'
require 'logger'
require 'dotenv/load'

# set up a Slack notifier
notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_URL']

# set up a logger
logger = Logger.new(STDOUT)

# define the route that will receive the POST request
post '/payload' do
  begin
    # parse the JSON payload
    payload = JSON.parse(request.body.read)
    # possible improvement: store the rest of the payload in a database, file or other data store
    # why? Because the payload contains a lot of useful information that can be used to improve your email deliverability.
    # check before implmenting this: Check it's ok to store the data in your country (GDPR, CCPA, etc.)

    # check if the payload matches the desired criteria
    if payload['Type'] == 'SpamNotification'
      # send a Slack alert with the email address included in the payload
      message = "New spam report from #{payload['Email']}"
      notifier.ping message
    end
    # possible improvement: do something else if the payload doesn't match the desired criteria

    # return a 200 OK status code to indicate success
    status 200
    # to verify: if this endpoint only expect spam reports, 
    # do we want to return a different status code if the payload doesn't match the desired criteria?

  rescue JSON::ParserError => e
    # handle JSON parsing errors
    logger.error "JSON parsing error: #{e}"
    status 400
    body 'Bad Request'

  rescue StandardError => e
    # handle all other errors
    logger.error "Error: #{e}"
    status 500
    body 'Internal Server Error'
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

# set up SSL/TLS for secure communication
set :bind, '0.0.0.0'
set :port, ENV['PORT']
set :ssl_certificate, ENV['SSL_CERTIFICATE']
set :ssl_key, ENV['SSL_KEY']
set :environment, :production

# enable HTTP Strict Transport Security (HSTS) for additional security
before do
  response.headers['Strict-Transport-Security'] = 'max-age=31536000; includeSubDomains; preload'
end
