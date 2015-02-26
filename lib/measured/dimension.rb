class Measured::Dimension
  def initialize(raw_value, unit)
    @raw_value = raw_value
    @unit = unit
  end

  attr_reader :unit

  def unit=(unit)
    @unit = unit
  end


end
