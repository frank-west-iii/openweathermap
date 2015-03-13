class Weather
  attr_reader :date, :temperature

  def initialize(date, temperature)
    @date = date
    @temperature = temperature
  end
end
