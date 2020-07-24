# frozen_string_literal: true

require 'date'

require 'rspec'

require_relative '../lib/verse_rule_generator'

class GetRandomStub
  attr_accessor :current_index

  def initialize
    @current_index = 0
  end

  def call(range)
    result = range.cycle.take(@current_index + 1).last
    @current_index += 1
    result
  end
end

RSpec.describe VerseRuleGenerator do
  subject(:generator) { described_class.new(get_random, get_today).call }

  let(:get_random) { GetRandomStub.new }
  let(:get_today) { object_double(Date.method(:new), call: today) }
  let(:today) { Date.new(1982, 12, 6) }

  describe '#call' do
    it 'generates a verse rule which property `values` uses `get_random`'\
       ' for each length' do
      expect(generator.values).to eq [1, 2, 3]
    end

    it 'generates a verse rule which property `created_at` uses `get_today`' do
      expect(generator.created_at).to eq today
    end

    it 'generates a verse rule which each length cannot be over 10' do
      get_random.current_index = 9
      expect(generator.values).to eq [10, 1, 2]
    end
  end
end
