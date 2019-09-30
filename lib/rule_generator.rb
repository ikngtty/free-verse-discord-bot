# frozen_string_literal: true

class RuleGenerator
  attr_accessor :ranges

  def initialize(get_rand, get_today)
    @ranges = [1..10] * 3
    @get_rand = get_rand
    @get_today = get_today
    @last_rule = nil
    @last_called_date = nil
  end

  def call
    today = @get_today.call
    return @last_rule if today == @last_called_date

    # include 2 patterns:
    # * first call (@last_called_date is nil)
    # * first call in a different day (@last_called_date is not nil)
    new_rule = ranges.map { |range| @get_rand.call(range) }
    @last_rule = new_rule
    @last_called_date = today
    new_rule
  end
end
