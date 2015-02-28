class Measured::Unit
  def initialize(name, aliases: [], value: nil)
    @name = name.to_s
    @names = [@name] + aliases.map{|n| n.to_s }
    @value = parse_value(value)
  end

  attr_reader :names

  private

  def parse_value(value_string)

  end
end
