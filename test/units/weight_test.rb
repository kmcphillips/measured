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

  test ".convert_to from g to g" do
    assert_conversion Measured::Weight, "2000 g", "2000 g"
  end

  test ".convert_to from g to kg" do
    assert_conversion Measured::Weight, "2000 g", "2 kg"
  end

  test ".convert_to from g to lb" do
    assert_conversion Measured::Weight, "2000 g", "0.4409245244E1 lb"
  end

  test ".convert_to from g to oz" do
    assert_conversion Measured::Weight, "2000 g", "70.547923904 oz"
  end

  test ".convert_to from kg to g" do
    assert_conversion Measured::Weight, "2000 kg", "2000000 g"
  end

  test ".convert_to from kg to kg" do
    assert_conversion Measured::Weight, "2000 kg", "2000 kg"
  end

  test ".convert_to from kg to lb" do
    assert_conversion Measured::Weight, "2000 kg", "4409.245244 lb"
  end

  test ".convert_to from kg to oz" do
    assert_conversion Measured::Weight, "2000 kg", "70547.923904 oz"
  end

  test ".convert_to from lb to g" do
    assert_conversion Measured::Weight, "2000 lb", "907184.74 g"
  end

  test ".convert_to from lb to kg" do
    assert_conversion Measured::Weight, "2000 lb", "907.18474 kg"
  end

  test ".convert_to from lb to lb" do
    assert_conversion Measured::Weight, "2000 lb", "2000 lb"
  end

  test ".convert_to from lb to oz" do
    assert_conversion Measured::Weight, "2000 lb", "32000 oz"
  end

  test ".convert_to from oz to g" do
    assert_conversion Measured::Weight, "2000 oz", "56699.04625 g"
  end

  test ".convert_to from oz to kg" do
    assert_conversion Measured::Weight, "2000 oz", "56.69904625 kg"
  end

  test ".convert_to from oz to lb" do
    assert_conversion Measured::Weight, "2000 oz", "125 lb"
  end

  test ".convert_to from oz to oz" do
    assert_conversion Measured::Weight, "2000 oz", "2000 oz"
  end

end
