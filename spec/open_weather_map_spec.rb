require 'open_weather_map'
require 'pry'

RSpec.describe OpenWeatherMap do
  context "getting the current forecast" do
    it 'should return the current forecast when successful' do
      stub_request(:get, "http://api.openweathermap.org/data/2.5/weather?q=Hanford,CA").
        to_return(:status => 200, :body => {main: {temp: 295.39}}.to_json)

      weather = OpenWeatherMap.new("Hanford,CA")
      results = weather.current_forecast

      expect(results).to eq("abc")
    end

    it 'should return an unknown result when unsuccessful' do
      stub_request(:get, "http://api.openweathermap.org/data/2.5/weather?q=Hanford,CA").
        to_return(:status => 404, :body => "abc")

      weather = OpenWeatherMap.new("Hanford,CA")
      results = weather.current_forecast

      expect(results).to eq("abc")
    end
  end

  context "getting the extended forecast" do
    it 'should return the extended forecast when successful' do
      stub_request(:get, "http://api.openweathermap.org/data/2.5/forecast?q=Hanford,CA").
        to_return(:status => 200, :body => "abc", :headers => {})

      weather = OpenWeatherMap.new("Hanford,CA")
      results = weather.extended_forecast

      expect(results).to eq("abc")
    end
  end
end
