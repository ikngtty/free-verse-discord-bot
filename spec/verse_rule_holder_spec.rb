# frozen_string_literal: true

require 'date'

require 'rspec'

require_relative '../lib/verse_rule'
require_relative '../lib/verse_rule_generator'
require_relative '../lib/verse_rule_holder'

RSpec.describe VerseRuleHolder do
  describe '#current' do
    subject(:holder) { described_class.new(generator, get_today) }

    let(:get_today) { object_double(Date.method(:new), call: today) }
    let(:today) { Date.new(1982, 12, 6) }

    def go_to_tommorow
      allow(get_today).to receive_messages(call: today + 1)
    end

    let(:generator) do
      obj = instance_double(VerseRuleGenerator)
      allow(obj).to receive(:call).and_return(rule1, rule2)
      obj
    end
    let(:rule1) do
      VerseRule.new(
        values: [1, 1, 1],
        created_at: today,
      )
    end
    let(:rule2) do
      VerseRule.new(
        values: [2, 2, 2],
        created_at: today + 1,
      )
    end

    it 'returns a new verse rule for the 1st call of the 1st day' do
      expect(holder.current).to eq rule1
    end

    it 'returns the existing verse rule for the 2nd call of the 1st day' do
      holder.current
      expect(holder.current).to eq rule1
    end

    it 'returns a new verse rule for the 1st call of the 2nd day' do
      holder.current
      holder.current

      go_to_tommorow

      expect(holder.current).to eq rule2
    end

    it 'returns the existing verse rule for the 2nd call of the 2nd day' do
      holder.current
      holder.current

      go_to_tommorow

      holder.current
      expect(holder.current).to eq rule2
    end

    it 'outputs a log when a new verse rule is created' do
      expect { holder.current }.to output("New Rule! [1, 1, 1]\n").to_stdout
    end

    it 'does not output a log when the existing verse rule is reused' do
      holder.current
      expect { holder.current }.not_to output(/New Rule/).to_stdout
    end

    it 'outputs a log when an old verse rule is updated' do
      holder.current
      holder.current

      go_to_tommorow

      expect { holder.current }.to output("New Rule! [2, 2, 2]\n").to_stdout
    end
  end
end
