# frozen_string_literal: true

require 'rspec'
require_relative '../lib/rule_generator'

class GetRandomStub
  attr_accessor :current_index

  def initialize
    @current_index = 0
  end

  def call(range)
    result = range.take(@current_index + 1).last
    @current_index += 1
    result
  end
end

RSpec.describe RuleGenerator do
  subject(:generator) { described_class.new(get_random) }

  let(:get_random) { GetRandomStub.new }

  describe '#call' do
    it 'generates a rule which uses get_random for each length' do
      expect(generator.call).to eq [1, 2, 3]
    end

    it 'changes the result by every call' do
      generator.call
      expect(generator.call).to eq [4, 5, 6]
    end

    it 'generates a rule which each length cannot be over 10' do
      get_random.current_index = 11
      expect(generator.call).to eq [10, 10, 10]
    end
  end
end
