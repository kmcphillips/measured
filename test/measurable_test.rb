require "test_helper"

class Measured::MeasurableTest < ActiveSupport::TestCase

  class Magic < Measured::Measurable
    conversion.base :magic_missile, :magic_missiles
    conversion.add :fire, :fireball, :fireballs, value: "2/3 magic_missile"
    conversion.add :ice, value: "2 magic_missile"
    conversion.add :arcane, value: "10 magic_missile"
    conversion.add :ultima, value: "10 arcane"
  end

  setup do
    @magic = Magic.new(1, "fire")
  end

  test "#initialize requires two params, the amount and the unit" do
    assert_nothing_raised do
      Magic.new(1, "fireball")
    end

    assert_raises ArgumentError do
      Magic.new(1)
    end
  end

  test "#unit allows you to read the unit string" do
    assert_equal "fire", @magic.unit
  end

  test "#unit= allows you to set the unit string" do
    @magic.unit = "magic_missile"
    assert_equal "magic_missile", @magic.unit
  end

  test "unit is coerced to string from symbol on #initialize and on #unit=" do
    dimension = Magic.new(1, :arcane)
    assert_equal "arcane", dimension.unit
    dimension.unit = :fireballs
    assert_equal "fireballs", dimension.unit
  end

  test "#unit= prevents you from assigning an unknown unit" do
    skip
  end

  test ".conversion is set and cached" do
    conversion = Magic.conversion

    assert_instance_of Measured::Conversion, conversion
    assert_equal conversion, Magic.conversion
  end

end
