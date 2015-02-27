require "test_helper"

class Measured::ConversionTest < ActiveSupport::TestCase
  setup do
    @conversion = Measured::Conversion.new
  end

  test "#base sets the base unit" do
    @conversion.base :m, :metre
    assert_equal ["m", "metre"], @conversion.base_unit.names
  end

  test "#base doesn't allow a second base to be added" do
    @conversion.base :m, :metre

    assert_raises Measured::UnitError do
      @conversion.base :in, :inch
    end
  end

  test "#add adds a new unit" do
    @conversion.base :m
    @conversion.add :in, :inch, value: "0.0254 meter"
  end

  test "#add does not allow blank unit names" do
    @conversion.base :m
    assert_raises Measured::UnitError do
      @conversion.add value: "0.0254 meter"
    end
  end

  test "#add cannot add duplicate unit names" do
    @conversion.base :m
    @conversion.add :in, :inch, value: "0.0254 meter"

    assert_raises Measured::UnitError do
      @conversion.add :in, :thing, value: "123 m"
    end
  end

  test "#add does not allow you to add a unit before the base" do
    assert_raises Measured::UnitError do
      @conversion.add :in, :inch, value: "0.0254 meter"
    end
  end

  test "#valid_units lists all allowed unit names" do
    @conversion.base :m
    @conversion.add :in, :inch, value: "0.0254 meter"
    @conversion.add :foot, :feet, :ft, value: "0.3048 meter"

    assert_equal ["feet", "foot", "ft", "in", "inch", "m"], @conversion.valid_units
  end
end
