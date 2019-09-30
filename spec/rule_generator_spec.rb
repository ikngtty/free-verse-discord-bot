# frozen_string_literal: true

require 'rspec'
require_relative '../lib/rule_generator'

RSpec.describe RuleGenerator do
  subject(:generator) { described_class.new }

  describe '#call' do
    it 'generates [3, 4, 5]' do
      expect(generator.call).to eq [3, 4, 5]
    end
  end
end
