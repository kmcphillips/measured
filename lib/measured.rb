require "measured/version"
require "active_support"
require "bigdecimal"

module Measured
  class UnitError < StandardError ; end
end

require "measured/measurable"
require "measured/unit"
require "measured/conversion"

require "measured/dimension"
