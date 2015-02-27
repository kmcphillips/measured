class Measured::Measurable
  def initialize(value, unit)
    @value = value
    @unit = unit.to_s
  end

  attr_reader :unit

  def unit=(unit)
    @unit = unit.to_s
  end

  class << self

    def conversion
      @conversion ||= Measured::Conversion.new
    end

  end
end
