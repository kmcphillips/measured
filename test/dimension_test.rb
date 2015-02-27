require "test_helper"

class Measured::DimensionTest < ActiveSupport::TestCase
  setup do
    @dimension = Measured::Dimension.new(1, "m")
  end


end
