class UnknownWeather
  attr_reader :date

  def initialize(date)
    @date = date
  end

  def temperature
    "Unknown"
  end
end
