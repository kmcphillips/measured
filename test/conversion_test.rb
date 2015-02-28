require "test_helper"

class Measured::ConversionTest < ActiveSupport::TestCase
  setup do
    @conversion = Measured::Conversion.new
  end

  test "#base sets the base unit" do
    @conversion.set_base :m, aliases: [:metre]
    assert_equal ["m", "metre"], @conversion.base_unit.names
  end

  test "#base doesn't allow a second base to be added" do
    @conversion.set_base :m, aliases: [:metre]

    assert_raises Measured::UnitError do
      @conversion.set_base :in
    end
  end

  test "#add adds a new unit" do
    @conversion.set_base :m
    @conversion.add :in, aliases: [:inch], value: "0.0254 meter"

    assert_equal 2, @conversion.units.count
  end

  test "#add cannot add duplicate unit names" do
    @conversion.set_base :m
    @conversion.add :in, aliases: [:inch], value: "0.0254 meter"

    assert_raises Measured::UnitError do
      @conversion.add :in, aliases: [:thing], value: "123 m"
    end

    assert_raises Measured::UnitError do
      @conversion.add :inch, value: "123 m"
    end
  end

  test "#add does not allow you to add a unit before the base" do
    assert_raises Measured::UnitError do
      @conversion.add :in, aliases: [:inch], value: "0.0254 meter"
    end
  end

  test "#valid_units lists all allowed unit names" do
    @conversion.set_base :m
    @conversion.add :in, aliases: [:inch], value: "0.0254 meter"
    @conversion.add :foot, aliases: [:feet, :ft], value: "0.3048 meter"

    assert_equal ["feet", "foot", "ft", "in", "inch", "m"], @conversion.valid_units
  end

  test "#valid_unit? checks if the unit is valid or not" do
    @conversion.set_base :m
    @conversion.add :inch, value: "0.0254 meter"

    assert @conversion.valid_unit?(:inch)
    assert @conversion.valid_unit?("m")
    refute @conversion.valid_unit?(:yard)
  end

  test "values are parsed into units and numbers as BigDecimals" do
    skip
    Magic.conversion.units[0]
  end
end
