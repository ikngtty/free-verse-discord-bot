# frozen_string_literal: true

require 'date'

require 'rspec'

require_relative '../lib/verse_rule'
require_relative '../lib/verse_rule_generator'
require_relative '../lib/verse_rule_repository_memory'
require_relative '../lib/verse_rule_updater'

RSpec.describe VerseRuleUpdater do
  subject(:updater) { described_class.new(repository, generator, get_today) }

  let(:repository) { VerseRuleRepositoryMemory.new }

  let(:get_today) { object_double(Date.method(:new), call: today) }
  let(:today) { Date.new(1982, 12, 6) }
  def go_to_tommorow
    allow(get_today).to receive_messages(call: today + 1)
  end

  let(:generator) do
    obj = instance_double(VerseRuleGenerator)
    allow(obj).to receive(:call).and_return(rule1, rule2, rule3)
    obj
  end
  let(:rule1) do
    VerseRule.new(
      values: [1, 1, 1],
      created_at: today
      # TODO: This is incorrect when the generator is called as unexpected.
    )
  end
  let(:rule2) do
    VerseRule.new(
      values: [2, 2, 2],
      created_at: today + 1
      # TODO: This is incorrect when the generator is called as unexpected.
    )
  end
  let(:rule3) do
    VerseRule.new(
      values: [3, 3, 3],
      created_at: today + 2
      # TODO: This is incorrect when the generator is called as unexpected.
    )
  end

  describe '#exec_as_needed' do
    context 'when the repository is empty' do
      it 'returns true' do
        expect(updater.exec_as_needed).to eq true
      end

      it 'sets a new verse rule to the repository' do
        updater.exec_as_needed
        expect(repository.current).to eq rule1
      end

      it 'outputs a log' do
        expect { updater.exec_as_needed }
          .to output("New Rule! [1, 1, 1]\n").to_stdout
      end
    end

    context 'when the repository has the rule of today' do
      before do
        updater.exec_as_needed
      end

      it 'returns false' do
        expect(updater.exec_as_needed).to eq false
      end

      it 'does not update the verse rule' do
        # TODO: This may not fail if the rule is updated to the same value.
        updater.exec_as_needed
        expect(repository.current).to eq rule1
      end

      it 'does not outputs a log' do
        expect { updater.exec_as_needed }
          .not_to output(/New Rule/).to_stdout
      end
    end

    context 'when the repository has the rule of yesterday' do
      before do
        updater.exec_as_needed
        updater.exec_as_needed
        go_to_tommorow
      end

      it 'returns true' do
        expect(updater.exec_as_needed).to eq true
      end

      it 'updates the verse rule' do
        updater.exec_as_needed
        expect(repository.current).to eq rule2
      end

      it 'outputs a log' do
        expect { updater.exec_as_needed }
          .to output("New Rule! [2, 2, 2]\n").to_stdout
      end
    end
  end
end
