require "test_helper"

class Measured::MeasurableTest < ActiveSupport::TestCase

  setup do
    @magic = Magic.new(1, :magic_missile)
  end

  test "#initialize requires two params, the amount and the unit" do
    assert_nothing_raised do
      Magic.new(1, "fireball")
    end

    assert_raises ArgumentError do
      Magic.new(1)
    end
  end

  test "#initialize converts unit to string from symbol" do
    dimension = Magic.new(1, :arcane)
    assert_equal "arcane", dimension.unit
  end

  test "#initialize raises if it is an unknown unit" do
    assert_raises Measured::UnitError do
      Magic.new(1, "slash")
    end
  end

  test "#initialize converts numbers and strings into BigDecimal" do
    assert_equal BigDecimal(1), Magic.new(1, :arcane).value
    assert_equal BigDecimal("2.3"), Magic.new("2.3", :arcane).value
    assert_equal BigDecimal("5"), Magic.new("5", :arcane).value
  end

  test "#unit allows you to read the unit string" do
    assert_equal "magic_missile", @magic.unit
  end

  test "#value allows you to read the numeric value" do
    assert_equal BigDecimal(1), @magic.value
  end

  test ".conversion is set and cached" do
    conversion = Magic.conversion

    assert_instance_of Measured::Conversion, conversion
    assert_equal conversion, Magic.conversion
  end

  test ".units returns all units" do
    assert_equal ["arcane", "fire", "fireball", "fireballs", "ice", "magic_missile", "magic_missiles", "ultima"], Magic.units
  end

  test "#convert_to raises on an invalid unit" do
    assert_raises Measured::UnitError do
      @magic.convert_to(:punch)
    end
  end

  test "#convert_to returns a new object of the same type in the new unit" do
    skip
  end

  test "#convert_to! replaces the existing object with a new version in the new unit" do
    skip
  end
end
