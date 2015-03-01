class Measured::ConversionTable

  def initialize(units, base_unit: base_unit)
    @units = units
    @base_unit = base_unit
    @units_without_base = @units.reject{|u| u == @base_unit}
  end

  def to_h
    table = {
      @base_unit.name => {@base_unit.name => BigDecimal("1")}
    }

    @units_without_base.map{|u| u.name}.each do |to_unit|
      to_table = {to_unit => BigDecimal("1")}

      table.each do |from_unit, from_table|
        to_table[from_unit] = find_conversion(units: @units_without_base, to: from_unit, from: to_unit)
        from_table[to_unit] = find_conversion(units: @units_without_base, to: to_unit, from: from_unit)
      end

      table[to_unit] = to_table
    end

    table
  end

  private

  def find_conversion(units:, to:, from:)
    # Look for a direct conversion
    units.each do |unit|
      return unit.conversion_amount if unit.name == from && unit.conversion_unit == to
    end

    # Look for a direct reverse conversion
    units.each do |unit|
      return BigDecimal(1) / unit.conversion_amount if unit.name == to && unit.conversion_unit == from
    end

    # Search recursively for an indirect conversion path
    units.each do |unit|
      if unit.name == from
        return unit.conversion_amount * find_conversion(units: units.dup - [unit], from: unit.conversion_unit, to: to)
      elsif unit.name == to
        return BigDecimal(1) / unit.conversion_amount * find_conversion(units: units.dup - [unit], from: from, to: unit.conversion_unit)
      end
    end

    raise Measured::UnitError, "Cannot find conversion path from #{ from } to #{ to }."
  end

end
