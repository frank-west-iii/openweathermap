require 'net/http'
require 'json'

class OpenWeatherMap
  def initialize(location)
    @location = location
  end

  def current_forecast
    get "weather"
  end

  def extended_forecast
    get "forecast"
  end

  private

  def get(path)
    Net::HTTP.get(URI "#{base_url}/#{path}?q=#{@location}")
  end

  def base_url
    'http://api.openweathermap.org/data/2.5'
  end
end
