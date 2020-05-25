# frozen_string_literal: true

class VerseRuleHolder
  def initialize(generate_rule, get_today)
    @generate_rule = generate_rule
    @get_today = get_today
    @last_rule = nil
  end

  def current
    today = @get_today.call
    return @last_rule if today == @last_rule&.created_at

    # include 2 patterns:
    # * first call (@last_rule is nil)
    # * first call in a different day (@last_rule is not nil)
    @last_rule = @generate_rule.call
    puts "New Rule! #{@last_rule.values}"
    @last_rule
  end
end
