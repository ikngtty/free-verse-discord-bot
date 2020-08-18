# frozen_string_literal: true

require 'json'
require 'redis'

require_relative 'verse_rule'

class VerseRuleRepositoryRedis
  KEY_CURRENT_RULE = 'current_rule'

  def current
    rule = redis.get(KEY_CURRENT_RULE)
    rule && JSON.parse(rule, create_additions: true)
  end

  def current=(rule)
    redis.set(KEY_CURRENT_RULE, JSON.generate(rule))
  end

  private

  def redis
    @redis ||= Redis.new
  end
end
