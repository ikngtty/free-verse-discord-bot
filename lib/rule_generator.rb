# frozen_string_literal: true

require_relative 'verse_rule'

class RuleGenerator
  attr_accessor :ranges

  def initialize(get_rand, get_today)
    @ranges = [1..10] * 3
    @get_rand = get_rand
    @get_today = get_today
    @last_rule = nil
  end

  def call
    today = @get_today.call
    return @last_rule.values if today == @last_rule&.created_at

    # include 2 patterns:
    # * first call (@last_rule is nil)
    # * first call in a different day (@last_rule is not nil)
    new_rule_values = ranges.map { |range| @get_rand.call(range) }
    puts "New Rule! #{new_rule_values}"
    @last_rule = VerseRule.new(
      values: new_rule_values,
      created_at: today
    )
    new_rule_values
  end
end
