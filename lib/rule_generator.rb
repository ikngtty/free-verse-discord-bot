# frozen_string_literal: true

class RuleGenerator
  attr_accessor :ranges

  def initialize(get_rand)
    @ranges = [1..10] * 3
    @get_rand = get_rand
  end

  def call
    ranges.map { |range| @get_rand.call(range) }
  end
end
