# frozen_string_literal: true

require 'json'
require 'json/add/date'

module VerseRule
  class VerseRule
    attr_reader :values, :created_at

    def self.json_create(obj)
      new(**obj.map { |key, value| [key.to_sym, value] }.to_h)
    end

    def initialize(args)
      @values = args.fetch(:values)
      @created_at = args.fetch(:created_at)
    end

    def as_json
      {
        JSON.create_id => self.class.name,
        values: @values,
        created_at: @created_at
      }
    end

    def to_json(*args)
      as_json.to_json(*args)
    end

    def ==(other)
      as_json == other.as_json
    end
  end
end
