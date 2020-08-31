# frozen_string_literal: true

module Fake
  class Redis
    def initialize
      @store = {}
      init_call_counts
    end

    def init_call_counts
      @call_counts = { get: 0, set: 0 }
    end

    def call_count_of_get
      @call_counts[:get]
    end

    def call_count_of_set
      @call_counts[:set]
    end

    def get(key)
      @call_counts[:get] += 1
      @store[key]
    end

    def set(key, value)
      @call_counts[:set] += 1
      @store[key] = value
    end
  end
end
