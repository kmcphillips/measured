require "test_helper"

class Measured::UnitTest < ActiveSupport::TestCase

  test "#initialize converts the name to a string" do
    assert_equal "pie", Measured::Unit.new(:pie).name
  end

  test "#initialize converts aliases to strings and makes a list of names which includes the base" do
    assert_equal ["cake", "pie", "sweets"], Measured::Unit.new(:pie, aliases: ["cake", :sweets]).names
  end

  test "#initialize parses out the unit and the number part" do
    unit = Measured::Unit.new(:pie, value: "10 cake")
    assert_equal BigDecimal(10), unit.conversion_amount
    assert_equal "cake", unit.conversion_unit

    unit = Measured::Unit.new(:pie, value: "5.5 sweets")
    assert_equal BigDecimal("5.5"), unit.conversion_amount
    assert_equal "sweets", unit.conversion_unit
  end

  test "#initialize raises if the format of the value is incorrect" do
    assert_raises Measured::UnitError do
      Measured::Unit.new(:pie, value: "hello")
    end

    assert_raises Measured::UnitError do
      Measured::Unit.new(:pie, value: "pie is delicious")
    end

    assert_raises Measured::UnitError do
      Measured::Unit.new(:pie, value: "123456")
    end
  end

  test "#to_s" do
    assert_equal "pie", Measured::Unit.new(:pie).to_s
    assert_equal "pie (1/2 sweet)", Measured::Unit.new(:pie, aliases: ["cake"], value: [Rational(1,2), "sweet"]).to_s
  end

  test "#inspect returns an expected string" do
    assert_equal "#<Measured::Unit: pie (pie) >", Measured::Unit.new(:pie).inspect
    assert_equal "#<Measured::Unit: pie (cake, pie) 1/2 sweet>", Measured::Unit.new(:pie, aliases: ["cake"], value: [Rational(1,2), "sweet"]).inspect
  end

end
