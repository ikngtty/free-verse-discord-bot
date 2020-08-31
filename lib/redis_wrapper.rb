# frozen_string_literal: true

class RedisWrapper
  def initialize(redis_client)
    @redis = redis_client
  end

  def get(key)
    value = @redis.get(key)
    puts "Got \"#{key}\" value from Redis: #{value}"
    value
  end

  def set(key, value)
    result = @redis.set(key, value)
    puts "Set \"#{key}\" value to Redis: #{value}"
    result
  end
end
