# frozen_string_literal: true

# NOTE: If too many times called, it uses large memory.
module Fake
  class GetRandom
    attr_accessor :current_index

    def initialize
      @current_index = 0
    end

    def call(range)
      result = range.cycle.take(@current_index + 1).last
      @current_index += 1
      result
    end
  end
end
