class Measured::Measurable
  def initialize(value, unit)
    validate_unit_name!(unit)

    @value = value
    @unit = unit.to_s
  end

  attr_reader :unit

  def convert_to(unit)
    validate_unit_name!(unit)

  end

  private

  def validate_unit_name!(name)
    raise Measured::UnitError, "Unit #{ name } does not exits." unless self.class.conversion.valid_unit?(name)
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
