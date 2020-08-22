# frozen_string_literal: true

module VerseRule
  class Updater
    def initialize(args)
      @repository = args.fetch(:repository)
      @generate_rule = args.fetch(:generate_rule)
      @get_today = args.fetch(:get_today)
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
end
