# frozen_string_literal: true

require_relative 'verse_rule_repository_memory'
require_relative 'verse_rule_updater'

class VerseRuleHolder
  def initialize(generate_rule, get_today)
    @repo = VerseRuleRepositoryMemory.new
    @updater = VerseRuleUpdater.new(@repo, generate_rule, get_today)
  end

  def current
    @updater.exec_as_needed
    @repo.current
  end
end
