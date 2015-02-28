class Measured::Unit
  def initialize(name, aliases: [], value: nil)
    @name = name.to_s
    @names = ([@name] + aliases.map{|n| n.to_s }).sort
    @conversion_amount, @conversion_unit = parse_value(value) if value
  end

  attr_reader :name, :names, :conversion_amount, :conversion_unit

  private

  def parse_value(value_string)
    tokens = value_string.split(" ")
    raise Measured::UnitError unless tokens.size == 2
    tokens[0] = BigDecimal(tokens[0])

    tokens
  end
end
