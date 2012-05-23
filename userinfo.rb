class UserInfo
  
  attr_reader :data

  #
  # Create a new UserInfo instance from the JSON returned by a Last.fm API query
  #
  def initialize(json_data)
    @data = json_data
  end

  #
  # Index directly into the data backing this UserInfo instance
  #
  # Calling this method is equivalent to accessing the returned JSON object directly
  #
  def [](x)
    return self.data[x]
  end

  def username
    return self.data["name"]
  end

  def url
    return self.data["url"]
  end

  def user_id
    return self.data["id"]
  end

  def play_count
    return (self.data["playcount"] || 0).to_i
  end

  def registration_time
    return Time.at self.data["registered"]["unixtime"].to_i
  end

  def days_registered
    return ((Time.now.to_i - self.registration_time.to_i).to_f / 60 / 60 / 24).floor
  end

  def plays_per_day(round = -1)
    val = self.play_count.to_f / self.days_registered
    return val if round < 0
    return val.round(round)
  end

end
