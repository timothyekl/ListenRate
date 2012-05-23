# Web-based requires
require 'sinatra/base'
require 'data_mapper'
require 'haml'

# Last.fm/configuration requires
require 'lastfm'
require 'parseconfig'

# Local files
Dir['./models/*.rb'].each {|f| require f}

class ListenRate < Sinatra::Base

  configure do
    # Set up lastfm global handler/interface
    config = ParseConfig.new(File.join(File.dirname(__FILE__), "lastfm-keys.conf"))
    $api_key = config.params['apikey']
    $lastfm = Lastfm.new(config.params['apikey'], config.params['secret'])

    # Configure DataMapper
    DataMapper.setup(:default, "sqlite://#{Dir.pwd}/users.sqlite")
    DataMapper.finalize
    DataMapper.auto_upgrade!
  end

  get '/' do
    haml :index
  end

  get '/info/:username' do
    username = params[:username]
    session = Session.first(:username => username)
    if session.nil?
      # Redirect to Last.fm for user authentication
      callback = "#{request.url}/configure"
      url = "http://www.last.fm/api/auth/?api_key=#{$api_key}&cb=#{callback}"
      redirect url
    else
      $lastfm.session = session.session_key
      $lastfm.user.get_info(username)
    end
  end

  get '/info/:username/configure' do
    # This is the authentication callback URL from Last.fm's API
    # We need to set up and remember a session key for the given user
    username = params[:username]
    token = params[:token] # this token is temporary to this request only
    session = Session.first_or_create(:username => username)

    session_key = $lastfm.auth.get_session(token)['key']

    session.session_key = session_key
    result = session.save

    redirect "/info/#{username}"
  end

  get '/style.css' do
    sass :style
  end

  run! if app_file == $0

end
