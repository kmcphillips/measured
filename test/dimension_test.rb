require "test_helper"

class Measured::DimensionTest < ActiveSupport::TestCase
  setup do
    @dimension = Measured::Dimension.new(1, "m")
  end

  test ".units_with_aliases should be the expected list of valid units" do
    assert_equal ["centimeter", "centimeters", "centimetre", "centimetres", "cm", "feet", "foot", "ft", "in", "inch", "inches", "m", "meter", "meters", "metre", "metres", "milliimeter", "milliimeters", "milliimetre", "milliimetres", "mm", "yard", "yards", "yd"], Measured::Dimension.units_with_aliases
  end

  test ".units should be the list of base units" do
    assert_equal ["cm", "ft", "in", "m", "mm", "yd"], Measured::Dimension.units
  end

  test "convert all units between all other units" do
    skip "TODO"
  end

end
