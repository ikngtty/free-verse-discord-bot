# frozen_string_literal: true

require_relative 'verse_rule_repository_memory'

class VerseRuleHolder
  def initialize(generate_rule, get_today)
    @generate_rule = generate_rule
    @get_today = get_today
    @repo = VerseRuleRepositoryMemory.new
  end

  def current
    today = @get_today.call
    return @repo.current if today == @repo.current&.created_at

    # include 2 patterns:
    # * first call (@repo.current is nil)
    # * first call in a different day (@repo.current is not nil)
    @repo.current = @generate_rule.call
    puts "New Rule! #{@repo.current.values}"
    @repo.current
  end
end
