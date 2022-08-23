# frozen_string_literal: true

require 'date'

require 'rspec'

require_relative '../../fake/verse_rule/repository_memory'
require_relative '../../shared_context/with_fixed_today'
require_relative '../../../lib/verse_rule/generator'
require_relative '../../../lib/verse_rule/updater'
require_relative '../../../lib/verse_rule/verse_rule'

RSpec.describe VerseRule::Updater do
  subject(:updater) do
    described_class.new(
      repository:,
      generate_rule:,
      get_today:
    )
  end

  include_context 'with fixed today'

  let(:repository) { Fake::VerseRule::RepositoryMemory.new }

  let(:generate_rule) do
    obj = instance_double(VerseRule::Generator)
    allow(obj).to receive(:call).and_return(rule1, rule2, rule3)
    obj
  end
  let(:rule1) do
    VerseRule::VerseRule.new(
      values: [1, 1, 1],
      created_at: BASE_DAY # NOTE: fake
    )
  end
  let(:rule2) do
    VerseRule::VerseRule.new(
      values: [2, 2, 2],
      created_at: BASE_DAY + 1 # NOTE: fake
    )
  end
  let(:rule3) do
    VerseRule::VerseRule.new(
      values: [3, 3, 3],
      created_at: BASE_DAY + 2 # NOTE: fake
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
        # HACK: This may not fail if the rule is updated to the same value.
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
