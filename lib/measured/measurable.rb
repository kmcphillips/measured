class Measured::Measurable
  def initialize(value, unit)
    raise Measured::UnitError, "Unit #{ unit } does not exits." unless self.class.conversion.valid_unit?(unit)

    @value = value
    @value = BigDecimal(@value) unless @value.is_a?(BigDecimal)

    @unit = unit.to_s
  end

  attr_reader :unit, :value

  def convert_to(new_unit)
    self.class.conversion.convert(@value, from: @unit, to: new_unit)
  end

  def convert_to!(new_unit)
    converted = convert_to(new_unit)

    @value = converted.value
    @unit = converted.unit

    self
  end

  class << self

    def conversion
      @conversion ||= Measured::Conversion.new
    end

    def units
      conversion.valid_units
    end

  end
end
