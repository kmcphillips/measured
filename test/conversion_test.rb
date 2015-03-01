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

  test "#convert raises if either unit is not found" do
    assert_raises Measured::UnitError do
      Magic.conversion.convert(1, from: "fire", to: "doesnt_exist")
    end

    assert_raises Measured::UnitError do
      Magic.conversion.convert(1, from: "doesnt_exist", to: "fire")
    end
  end

  test "#convert converts betwen two known units" do
    @conversion.set_base :m
    @conversion.add :cm, value: "0.01 m"

    assert_equal BigDecimal("10"), @conversion.convert(BigDecimal("1000"), from: "cm", to: "m")
    assert_equal BigDecimal("250"), @conversion.convert(BigDecimal("2.5"), from: "m", to: "cm")
  end

  test "#convert handles the same unit" do
    @conversion.set_base :m
    @conversion.add :cm, value: "0.01 m"

    assert_equal BigDecimal("2"), @conversion.convert(BigDecimal("2"), from: "cm", to: "cm")
  end

  test "#conversion_table returns expected nested hashes with BigDecimal conversion factors in a tiny data set" do
    @conversion.set_base :m
    @conversion.add :cm, value: "0.01 m"

    expected = {
      "m"  => {
        "m"  => BigDecimal("1"),
        "cm" => BigDecimal("100")
      },
      "cm" => {
        "cm" => BigDecimal("1"),
        "m"  => BigDecimal("0.01")
      }
    }

    assert_equal expected, @conversion.conversion_table
  end

  test "#conversion_table returns expected nested hashes with BigDecimal conversion factors" do
    @conversion.set_base :m
    @conversion.add :cm, value: "0.01 m"
    @conversion.add :mm, value: "0.001 m"

    expected = {
      "m"  => {
        "m"  => BigDecimal("1"),
        "cm" => BigDecimal("100"),
        "mm" => BigDecimal("1000")
      },
      "cm" => {
        "cm" => BigDecimal("1"),
        "m"  => BigDecimal("0.01"),
        "mm" => BigDecimal("10")
      },
      "mm" => {
        "mm" => BigDecimal("1"),
        "m"  => BigDecimal("0.001"),
        "cm" => BigDecimal("0.1")
      }
    }

    assert_equal expected, @conversion.conversion_table
  end

  test "#conversion_table returns expected nested hashes with BigDecimal conversion factors in an indrect path" do
    skip
    @conversion.set_base :single
    @conversion.add :double, value: "2 single"
    @conversion.add :quad, value: "2 double"

    expected = {
      "single"  => {
        "single"  => BigDecimal("1"),
        "double" => BigDecimal("2"),
        "quad" => BigDecimal("4")
      },
      "double" => {
        "double" => BigDecimal("1"),
        "single"  => BigDecimal("0.5"),
        "quad" => BigDecimal("2")
      },
      "quad" => {
        "quad" => BigDecimal("1"),
        "single"  => BigDecimal("0.25"),
        "double" => BigDecimal("0.5")
      }
    }

    assert_equal expected, @conversion.conversion_table
  end

end
