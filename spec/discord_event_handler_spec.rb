# frozen_string_literal: true

require 'discordrb'
require 'rspec'

require_relative '../lib/discord_event_handler'

RSpec.describe DiscordEventHandler do
  subject(:handler) { described_class.new(bot: true, discordrb_bot: true) }

  describe '#analyze' do
    subject(:analyze) { handler.method(:analyze) }

    let(:analyze_result) { described_class.const_get(:AnalyzeResult) }

    it 'regards a message without a mention as not a command' do
      result = analyze.call('abc', 123, 234)

      expect(result.command?).to be false
    end

    it 'regards a message which has mention in middle as not a command' do
      result = analyze.call('abc <@123>', 123, 234)

      expect(result.command?).to be false
    end

    it 'regards a message which begins with mention as a command' do
      result = analyze.call('<@123> abc', 123, 234)

      expect(result.command?).to be true
    end

    it 'regards a message which begins with mention through its nickname as a command' do
      result = analyze.call('<@!123> abc', 123, 234)

      expect(result.command?).to be true
    end

    it 'regards a message which begins with mention to its role as a command' do
      result = analyze.call('<@&234> abc', 123, 234)

      expect(result.command?).to be true
    end

    it 'finds a command and arguments' do
      result = analyze.call('<@123> abc def', 123, 234)

      expect(result).to eq \
        analyze_result.new(command?: true, command: 'abc', args_text: 'def')
    end

    it 'regards some sequential spaces as a separator' do
      result = analyze.call('<@123>   abc   def', 123, 234)

      expect(result).to eq \
        analyze_result.new(command?: true, command: 'abc', args_text: 'def')
    end
  end
end
