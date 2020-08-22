# frozen_string_literal: true

require 'date'

require 'rspec'

require_relative 'fake/get_random'
require_relative 'shared_context/with_fixed_today'
require_relative '../lib/verse_rule_generator'

RSpec.describe VerseRuleGenerator do
  subject(:generator) do
    described_class.new(get_random: get_random, get_today: get_today).call
  end

  include_context 'with fixed today'

  let(:get_random) { Fake::GetRandom.new }

  describe '#call' do
    it 'generates a verse rule which property `values` uses `get_random`'\
       ' for each length' do
      expect(generator.values).to eq [1, 2, 3]
    end

    it 'generates a verse rule which property `created_at` uses `get_today`' do
      expect(generator.created_at).to eq @today
    end

    it 'generates a verse rule which each length cannot be over 10' do
      get_random.current_index = 9
      expect(generator.values).to eq [10, 1, 2]
    end
  end
end
