# frozen_string_literal: true

require_relative 'verse_rule_repository_memory'

class VerseRuleUpdater
  def initialize(repository, generate_rule, get_today)
    @repository = repository
    @generate_rule = generate_rule
    @get_today = get_today
  end

  def exec_as_needed
    return false if @get_today.call == @repository.current&.created_at

    # include 2 patterns:
    # * first call (@repository.current is nil)
    # * first call in a different day (@repository.current is not nil)
    @repository.current = @generate_rule.call
    puts "New Rule! #{@repository.current.values}"

    true
  end
end
