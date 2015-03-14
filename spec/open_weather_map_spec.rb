require 'open_weather_map'
require 'unknown_weather'

RSpec.describe OpenWeatherMap do
  context "getting the current forecast" do
    it 'should return the current forecast when successful' do
      stub_request(:get, "http://api.openweathermap.org/data/2.5/weather?q=Hanford,CA").
        to_return(:status => 200, :body => {main: {temp: 295.39}}.to_json)

      Timecop.freeze(Time.now) do
        weather = OpenWeatherMap.new("Hanford,CA")
        result = weather.current_forecast

        expect(result.date).to eq(Time.now)
        expect(result.temperature).to eq(295.39)
      end
    end

    it 'should return the unknown forecast when not successful' do
      stub_request(:get, "http://api.openweathermap.org/data/2.5/weather?q=Hanford,CA").
        to_return(:status => 500, :body => {}.to_json)

      Timecop.freeze(Time.now) do
        weather = OpenWeatherMap.new("Hanford,CA")
        result = weather.current_forecast

        expect(result.date).to eq(Time.now)
        expect(result.temperature).to eq('Unknown')
      end
    end
  end

  context "getting the extended forecast" do
    it 'should return the extended forecast when successful' do
      stub_request(:get, "http://api.openweathermap.org/data/2.5/forecast?q=Hanford,CA").
        to_return(:status => 200, :body => {list: [
                  {dt_txt: '2015-03-06 03:00:00',
                    main: {temp: 298.32}},
                    {dt_txt: '2015-03-06 06:00:00',
                      main: {temp: 302.72}}]}.to_json)

      weather = OpenWeatherMap.new("Hanford,CA")
      results = weather.extended_forecast

      expect(results.count).to eq(2)
      expect(results.first.temperature).to eq(298.32)
      expect(results.first.date).to eq(Time.parse('2015-03-06 03:00:00'))
      expect(results.last.temperature).to eq(302.72)
      expect(results.last.date).to eq(Time.parse('2015-03-06 06:00:00'))
    end

    it 'should return the unknown forecast when not successful' do
      stub_request(:get, "http://api.openweathermap.org/data/2.5/forecast?q=Hanford,CA").
        to_return(:status => 500, :body => {}.to_json)

      Timecop.freeze(Time.now) do
        weather = OpenWeatherMap.new("Hanford,CA")
        result = weather.extended_forecast.first

        expect(result.date).to eq(Time.now)
        expect(result.temperature).to eq('Unknown')
      end
    end
  end
end
