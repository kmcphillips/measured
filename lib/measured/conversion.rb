class Measured::Conversion
  def initialize
    @base_unit = nil
    @units = []
  end

  attr_reader :base_unit, :units

  def base(*names)
    raise Measured::UnitError, "Can only have one base unit. Already defined #{ @base_unit }." if @base_unit
    check_unit_names(names)

    @base_unit = Unit.new(names)
    @units << @base_unit

    self
  end

  def add(*names, value:)
    raise Measured::UnitError, "A base unit has not yet been set." unless @base_unit
    check_unit_names(names)

    @units << Unit.new(names, value: value)

    self
  end

  def valid_units
    @units.map{|u| u.names}.flatten.sort
  end

  private

  def check_unit_names(names)
    raise Measured::UnitError, "Unit must have a name." if names.length == 0

    names.map{|n| n.to_s }.each do |name|
      raise Measured::UnitError, "Unit #{ name } has already been added." if valid_units.include?(name)
    end

    true
  end

  class Unit
    def initialize(names, value: nil)
      @names = names.map{|n| n.to_s }
      @value = value
    end

    attr_reader :names
  end

end
