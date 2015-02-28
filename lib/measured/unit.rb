class Measured::Unit
  def initialize(name, aliases: [], value: nil)
    @name = name.to_s
    @names = ([@name] + aliases.map{|n| n.to_s }).sort

    @conversion_amount, @conversion_unit = parse_value(value) if value
  end

  attr_reader :name, :names, :conversion_amount, :conversion_unit

  def to_s
    if conversion_string
      "#{ @name } (#{ conversion_string })"
    else
      @name
    end
  end

  def inspect
    "#<Measured::Unit: #{ @name } (#{ @names.join(", ") }) #{ conversion_string }>"
  end

  private

  def conversion_string
    "#{ conversion_amount } #{ conversion_unit }" if @conversion_amount || @conversion_unit
  end

  def parse_value(tokens)
    tokens = tokens.split(" ") if tokens.is_a?(String)
    raise Measured::UnitError unless tokens.size == 2

    tokens[0] = BigDecimal(tokens[0]) unless tokens[0].is_a?(BigDecimal) || tokens[0].is_a?(Rational)

    tokens
  end
end
