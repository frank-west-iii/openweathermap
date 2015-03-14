require 'hurley'
require 'json'
require 'weather'
require 'hashie'

class OpenWeatherMap
  def initialize(location)
    @location = location
  end

  def current_forecast
    get 'weather' do |response|
      Weather.new(Time.now,
                  response.main.temp)
    end
  end

  def extended_forecast
    result = get 'forecast' do |response|
      response.list.each_with_object([]) do |item, list|
        list << Weather.new(Time.parse(item.dt_txt),
                            item.main.temp)
      end
    end
    Array(result)
  end

  private

  def get(path, &block)
    response = client.get("/data/2.5/#{path}?q=#{@location}")
    if response.success?
      yield Hashie::Mash.new(JSON.parse(response.body))
    else
      UnknownWeather.new(Time.now)
    end
  end

  def client
    client = Hurley::Client.new base_url
    client.header[:content_type] = "application/json"
    client
  end

  def base_url
    'http://api.openweathermap.org'
  end
end
