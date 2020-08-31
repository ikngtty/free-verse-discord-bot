# frozen_string_literal: true

require 'json'
require 'rspec'

require_relative '../fake/redis'
require_relative '../shared_context/with_fixed_today'
require_relative '../../lib/verse_rule/repository_redis'
require_relative '../../lib/verse_rule/verse_rule'

RSpec.describe VerseRule::RepositoryRedis do
  subject(:repo) { described_class.new(redis_client: redis) }

  include_context 'with fixed today'

  let(:redis) { Fake::Redis.new }
  let(:rule1) do
    VerseRule::VerseRule.new(values: [1, 2, 3], created_at: @today)
  end
  let(:rule2) do
    VerseRule::VerseRule.new(values: [2, 3, 4], created_at: @today + 1)
  end

  describe '#current' do
    context 'when redis has no data' do
      it 'returns nil' do
        expect(repo.current).to be_nil
      end

      it 'trys to get value from redis' do
        repo.current
        expect(redis.call_count_of_get).to eq 1
      end

      it 'does not cache' do
        repo.current
        repo.current
        expect(redis.call_count_of_get).to eq 2
      end
    end

    context 'when redis has data but it is not cached' do
      before do
        redis.set(
          VerseRule::RepositoryRedis::KEY_CURRENT_RULE,
          JSON.generate(rule1)
        )
        redis.init_call_counts
      end

      it 'returns redis data' do
        expect(repo.current).to eq rule1
      end

      it 'trys to get value from redis' do
        repo.current
        expect(redis.call_count_of_get).to eq 1
      end

      it 'caches data' do
        repo.current
        redis.init_call_counts
        repo.current
        expect(redis.call_count_of_get).to eq 0
      end
    end

    # NOTE: It depends on "#current="'s spec.
    context 'when redis has data and it is cached' do
      before do
        repo.current = rule1
        redis.init_call_counts
      end

      it 'returns cached data' do
        redis.set(
          VerseRule::RepositoryRedis::KEY_CURRENT_RULE,
          JSON.generate(rule2)
        )
        expect(repo.current).to eq rule1
      end

      it 'does not try to get value from redis' do
        repo.current
        expect(redis.call_count_of_get).to eq 0
      end
    end
  end

  describe '#current=' do
    before do
      repo.current = rule1
    end

    it 'sets the value to redis' do
      redis_value = JSON.parse(
        redis.get(VerseRule::RepositoryRedis::KEY_CURRENT_RULE),
        create_additions: true
      )
      expect(redis_value).to eq rule1
    end

    # NOTE: It depends on "#current"'s spec.
    it 'sets the value to cache' do
      redis.set(
        VerseRule::RepositoryRedis::KEY_CURRENT_RULE,
        JSON.generate(rule2)
      )
      expect(repo.current).to eq rule1
    end
  end
end
