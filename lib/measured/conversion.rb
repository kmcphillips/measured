class Measured::Conversion
  def initialize
    @base_unit = nil
    @units = []
  end

  attr_reader :base_unit, :units

  def set_base(unit_name, aliases: [])
    add_new_unit(unit_name, aliases: aliases, base: true)
  end

  def add(unit_name, aliases: [], value:)
    add_new_unit(unit_name, aliases: aliases, value: value)
  end

  def valid_units
    @units.map{|u| u.names}.flatten.sort
  end

  def valid_unit?(unit)
    valid_units.include?(unit.to_s)
  end

  def convert(value, from:, to:)
    raise Measured::UnitError, "Source unit #{ from } does not exits." unless valid_unit?(from)
    raise Measured::UnitError, "Converted unit #{ to } does not exits." unless valid_unit?(to)

    from_unit = unit_for(from)
    to_unit = unit_for(to)

    value * conversion_table[from][to]
  end

  def conversion_table
    @conversion_table ||= build_conversion_table(@units, base_unit: @base_unit)
  end

  private

  def add_new_unit(unit_name, aliases:, value: nil, base: false)
    if base && @base_unit
      raise Measured::UnitError, "Can only have one base unit. Adding #{ unit_name } but already defined #{ @base_unit }."
    elsif !base && !@base_unit
      raise Measured::UnitError, "A base unit has not yet been set."
    end

    check_for_duplicate_unit_names([unit_name] + aliases)

    unit = Measured::Unit.new(unit_name, aliases: aliases, value: value)
    @units << unit
    @base_unit = unit if base

    clear_conversion_table

    unit
  end

  def check_for_duplicate_unit_names(names)
    names.each do |name|
      raise Measured::UnitError, "Unit #{ name } has already been added." if valid_unit?(name)
    end
  end

  def unit_for(name)
    @units.each do |unit|
      return unit if unit.names.include?(name.to_s)
    end

    raise Measured::UnitError, "Cannot find unit for #{ name }."
  end

  ###

  def build_conversion_table(units, base_unit: base_unit)
    # TODO should do this with inject
    table = {base_unit.name => {base_unit.name => BigDecimal("1")}}

    units.reject{|u| u == base_unit}.each do |to_unit|
      to_table = {to_unit.name => BigDecimal("1")}

      table.each do |from_unit_name, from_table|
        to_table[from_unit_name] = find_conversion_amount(units: units, to: from_unit_name, from: to_unit.name)
        from_table[to_unit.name] = find_conversion_amount(units: units, to: to_unit.name, from: from_unit_name)
      end

      table[to_unit.name] = to_table
    end

    table
  end

  def find_conversion_amount(units:, to:, from:)
    units.reject{|unit| !unit.conversion_amount }.each do |unit|
      if unit.name == from && unit.conversion_unit == to
        return unit.conversion_amount
      elsif unit.name == to && unit.conversion_unit == from
        return BigDecimal(1) / unit.conversion_amount
      elsif unit.name == from
        return unit.conversion_amount * find_conversion_amount(units: units.dup - [unit], from: unit.conversion_unit, to: to)
      elsif unit.name == to
        return BigDecimal(1) / unit.conversion_amount * find_conversion_amount(units: units.dup - [unit], from: from, to: unit.conversion_unit)
      end
    end

    raise Measured::UnitError, "Cannot find conversion path from #{ from } to #{ to }."
  end

  ###

  def clear_conversion_table
    @conversion_table = nil
  end

end
