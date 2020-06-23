# frozen_string_literal: true

require 'date'

require 'rspec'

require_relative '../lib/rule_generator'

class GetRandomStub
  attr_accessor :current_index

  def initialize
    @current_index = 2
  end

  def call(range)
    result = range.take(@current_index + 1).last
    @current_index += 1
    result
  end
end

RSpec.describe RuleGenerator do
  subject(:generator) { described_class.new(get_random, get_today) }

  let(:get_random) { GetRandomStub.new }
  let(:get_today) { object_double(Date.method(:new), call: today) }
  let(:today) { Date.new(1982, 12, 6) }

  def go_to_tommorow
    allow(get_today).to receive_messages(call: today + 1)
  end

  describe '#call' do
    it 'generates a rule which uses get_random for each length' do
      expect(generator.call).to eq [1, 2, 3]
    end

    it 'does not change the rule at the same day' do
      first = generator.call
      second = generator.call
      expect(second).to eq first
    end

    it 'changes the rule at the different day' do
      first = generator.call
      go_to_tommorow
      second = generator.call
      expect(second).not_to eq first
    end

    it 'does not change the rule at the same day after the change' do
      generator.call
      go_to_tommorow
      second = generator.call
      third = generator.call
      expect(third).to eq second
    end

    it 'generates a rule which each length cannot be over 10' do
      get_random.current_index = 11
      expect(generator.call).to eq [10, 10, 10]
    end

    it 'outputs a log when a new rule is created' do
      expect { generator.call }.to output("New Rule! [1, 2, 3]\n").to_stdout
    end

    it 'does not output a log when an old rule is reused' do
      generator.call
      expect { generator.call }.not_to output(/New Rule/).to_stdout
    end

    it 'outputs a log when an old rule is updated' do
      generator.call
      go_to_tommorow
      expect { generator.call }.to output("New Rule! [4, 5, 6]\n").to_stdout
    end
  end
end
