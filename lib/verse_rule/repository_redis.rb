# frozen_string_literal: true

require 'json'

require_relative 'verse_rule'

module VerseRule
  class RepositoryRedis
    KEY_CURRENT_RULE = 'current_rule'

    def initialize(args)
      @redis = args.fetch(:redis_client)
    end

    def current
      return @current_rule unless @current_rule.nil?

      rule = @redis.get(KEY_CURRENT_RULE)
      @current_rule = rule && JSON.parse(rule, create_additions: true)
    end

    def current=(rule)
      @redis.set(KEY_CURRENT_RULE, JSON.generate(rule))
      @current_rule = rule
    end
  end
end
