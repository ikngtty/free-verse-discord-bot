# frozen_string_literal: true

require_relative 'verse_rule'

module VerseRule
  class Generator
    attr_accessor :ranges

    def initialize(args)
      @ranges = [1..10] * 3
      @get_random = args.fetch(:get_random)
      @get_today = args.fetch(:get_today)
    end

    def call
      VerseRule.new(
        values: ranges.map { |range| @get_random.call(range) },
        created_at: @get_today.call
      )
    end
  end
end
