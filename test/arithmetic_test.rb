require "test_helper"

class Measured::ArithmeticTest < ActiveSupport::TestCase
  setup do
    @two = Magic.new(2, :magic_missile)
    @three = Magic.new(3, :magic_missile)
    @four_in_different_unit = Magic.new(2, :ice)
  end

  test "#+ should add together same units" do
    assert_equal Magic.new(5, :magic_missile), @two + @three
    assert_equal Magic.new(5, :magic_missile), @three + @two
  end

  test "#+ should add a number to the value" do
    assert_equal Magic.new(5, :magic_missile), @two + 3
    assert_equal Magic.new(5, :magic_missile), 2 + @three
  end

  test "#+ should raise if different unit system" do
    assert_raises TypeError do
      OtherFakeSystem.new(1, :other_fake_base) + @two
    end

    assert_raises TypeError do
      @two + OtherFakeSystem.new(1, :other_fake_base)
    end
  end

  test "#+ should raise if adding something nonsense" do
    assert_raises TypeError do
      @two + "thing"
    end

    assert_raises TypeError do
      "thing" + @two
    end
  end

  test "#-" do
    skip
  end

  test "#*" do
    skip
  end

  test "#/" do
    skip
  end
end
