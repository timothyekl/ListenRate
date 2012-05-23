# Web-based requires
require 'sinatra/base'
require 'data_mapper'
require 'haml'

# Last.fm/configuration requires
require 'lastfm'
require 'parseconfig'

# Debugging
require 'pp'

# Local files
Dir['./models/*.rb'].each {|f| require f}

class ListenRate < Sinatra::Base

  configure do
    # Set up lastfm global handler/interface
    config = ParseConfig.new(File.join(File.dirname(__FILE__), "lastfm-keys.conf"))
    $lastfm = Lastfm.new(config.params['apikey'], config.params['secret'])
    $token = $lastfm.auth.get_token

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
      # TODO handle the redirection crap
      "Need to do magic"
    else
      $lastfm.session = session.session_key
      pp $lastfm.user.get_info(username)
      "It worked!"
    end
  end

  get '/style.css' do
    sass :style
  end

  run! if app_file == $0

end
