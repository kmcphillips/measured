class Measured::Measurable
  def initialize(value, unit)
    raise Measured::UnitError, "Unit #{ unit } does not exits." unless self.class.conversion.valid_unit?(unit)

    @value = value
    @unit = unit.to_s
  end

  attr_reader :unit

  def convert_to(new_unit)
    self.class.conversion.convert(@value, from: @unit, to: new_unit)
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
