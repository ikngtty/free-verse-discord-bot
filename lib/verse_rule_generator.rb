# frozen_string_literal: true

require_relative 'verse_rule'

class VerseRuleGenerator
  attr_accessor :ranges

  def initialize(get_rand, get_today)
    @ranges = [1..10] * 3
    @get_rand = get_rand
    @get_today = get_today
  end

  def call
    VerseRule.new(
      values: ranges.map { |range| @get_rand.call(range) },
      created_at: @get_today.call
    )
  end
end
