module Measured::Arithmetic
  def +(other)
    if other.is_a?(self.class)
      self.class.new(self.value + other.convert_to(self.unit).value, self.unit)
    elsif other.is_a?(Numeric)
      self.class.new(self.value + other, self.unit)
    else
      raise TypeError, "Cannot add #{ other } to #{ self }"
    end
  end

  def -(other)
    if other.is_a?(self.class)
      self.class.new(self.value - other.convert_to(self.unit).value, self.unit)
    elsif other.is_a?(Numeric)
      self.class.new(self.value - other, self.unit)
    else
      raise TypeError, "Cannot add #{ other } to #{ self }"
    end
  end

  def *(other)
    if value.is_a? Numeric
      # Money.new(fractional * value, currency)
      # TODO
    else
      raise ArgumentError, "TODO"
    end
  end

  def /(other)
  end

  def -@
    self.class.new(-self.value, self.unit)
  end

  def coerce(other)
    [self, other]
  end
end
