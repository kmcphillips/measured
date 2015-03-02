require "test_helper"

class Measured::WeightTest < ActiveSupport::TestCase
  setup do
    @weight = Measured::Weight.new(1, "g")
  end

  test ".units_with_aliases should be the expected list of valid units" do
    assert_equal ["g", "gram", "grams", "kg", "kilogram", "kilograms", "lb", "lbs", "ounce", "ounces", "oz", "pound", "pounds"], Measured::Weight.units_with_aliases
  end

  test ".units should be the list of base units" do
    assert_equal ["g", "kg", "lb", "oz"], Measured::Weight.units
  end

  test "convert all units between all other units" do
    skip "TODO"
  end

end
