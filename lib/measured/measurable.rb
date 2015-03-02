class Measured::Measurable
  def initialize(value, unit)
    raise Measured::UnitError, "Unit #{ unit } does not exits." unless self.class.conversion.unit_or_alias?(unit)

    @value = value
    @value = BigDecimal(@value) unless @value.is_a?(BigDecimal)

    @unit = self.class.conversion.to_unit_name(unit)
  end

  attr_reader :unit, :value

  def convert_to(new_unit)
    new_unit_name = self.class.conversion.to_unit_name(new_unit)
    value = self.class.conversion.convert(@value, from: @unit, to: new_unit_name)

    self.class.new(value, new_unit)
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
      conversion.unit_names
    end

    def units_with_aliases
      conversion.unit_names_with_aliases
    end

  end
end
