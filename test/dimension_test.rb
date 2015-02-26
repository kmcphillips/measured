require "test_helper"

class Measured::DimensionTest < ActiveSupport::TestCase
  setup do
    @dimension = Measured::Dimension.new(1, "cm")
  end

  test "#initialize requires two params, the amount and the unit" do
    assert_nothing_raised do
      Measured::Dimension.new(1, "cm")
    end

    assert_raises ArgumentError do
      Measured::Dimension.new(1)
    end
  end

  test "#unit allows you to read the unit string" do
    assert_equal "cm", @dimension.unit
  end

  test "#unit= allows you to set the unit string" do
    @dimension.unit = "mm"
    assert_equal "mm", @dimension.unit
  end

  test "unit is coerced to string from symbol on #initialize and on #unit=" do
    dimension = Measured::Dimension.new(1, :cm)
    assert_equal "cm", dimension.unit
    dimension.unit = :mm
    assert_equal "mm", dimension.unit
  end

  test "#unit= prevents you from assigning an unknown unit" do
    skip
  end
end
