class Session
  include DataMapper::Resource

  property :username, String, :key => true
  property :session_key, String
end
