# frozen_string_literal: true

require_relative 'verse_rule_generator'
require_relative 'verse_rule_holder'

class RuleGenerator
  def initialize(get_rand, get_today)
    generator = VerseRuleGenerator.new(get_rand, get_today)
    @holder = VerseRuleHolder.new(generator, get_today)
  end

  def call
    @holder.current.values
  end
end
