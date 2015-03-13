require 'net/http'
require 'json'
require 'weather'

class OpenWeatherMap
  def initialize(location)
    @location = location
  end

  def current_forecast
    result = get 'weather'
    Weather.new(Time.now, result['main']['temp'])
  end

  def extended_forecast
    result = get 'forecast'
    result['list'].each_with_object([]) do |item, list|
      list << Weather.new(Time.parse(item['dt_txt']),
                          item['main']['temp'])
    end
  end

  private

  def get(path)
    JSON.parse(Net::HTTP.get(URI "#{base_url}/#{path}?q=#{@location}"))
  end

  def base_url
    'http://api.openweathermap.org/data/2.5'
  end
end
