# frozen_string_literal: true

require 'discordrb'
require 'rspec'

require_relative '../shared_context/with_discordrb_double'
require_relative '../shared_context/with_server_double'
require_relative '../../lib/bot'
require_relative '../../lib/discord_event_handler'

RSpec.describe DiscordEventHandler do
  subject(:handler) { described_class.new(bot:, discordrb_bot:) }

  include_context 'with discordrb double'
  include_context 'with server double'

  let(:bot) { instance_double(Bot) }

  describe '#handle_message_event' do
    let(:event) do
      val = instance_double(
        Discordrb::Events::MessageEvent,
        author: author_holder[:value],
        content: content_holder[:value],
        server: server_holder[:value]
      )
      class << val
        def respond(_text)
          'dummy'
        end
      end
      val
    end
    let(:author_holder) { { value: member2 } }
    let(:content_holder) { { value: 'hello' } }
    let(:server_holder) { { value: server } }
    let(:respond) { event.method(:respond) }

    it 'does not call any method when message\'s author is a bot' do
      author_holder[:value] = member_bot1
      handler.handle_message_event(event)
    end

    it 'does not call any method when recieved a private message while a server does not exist' do
      server_holder[:value] = nil
      handler.handle_message_event(event)
    end

    it 'calls `detect` method' do
      content = content_holder[:value]
      expect(bot).to receive(:detect).with(content, respond)
      handler.handle_message_event(event)
    end

    it 'calls a command when the head is mention' do
      content = "<@#{bot_id}> unknown"
      content_holder[:value] = content
      expect(bot).to receive(:unknown_command).with(respond)
      handler.handle_message_event(event)
    end

    it 'calls a command when the head is nickname mention' do
      content = "<@!#{bot_id}> unknown"
      content_holder[:value] = content
      expect(bot).to receive(:unknown_command).with(respond)
      handler.handle_message_event(event)
    end

    it 'calls a command when the head is role mention' do
      content = "<@&#{role_bot_me.id}> unknown"
      content_holder[:value] = content
      expect(bot).to receive(:unknown_command).with(respond)
      handler.handle_message_event(event)
    end

    it 'does not call any command when the mention part is in the middle' do
      content = "-> <@#{bot_id}> unknown"
      content_holder[:value] = content
      expect(bot).to receive(:detect).with(content, respond)
      handler.handle_message_event(event)
    end

    it 'calls `mecab_command` method when `mecab` is specified' do
      content = "<@#{bot_id}> mecab abc def"
      content_holder[:value] = content
      expect(bot).to receive(:mecab_command).with('abc def', respond)
      handler.handle_message_event(event)
    end

    it 'calls `unknown_command` method when unknown command is specified' do
      content = "<@#{bot_id}> <- mecab"
      content_holder[:value] = content
      expect(bot).to receive(:unknown_command).with(respond)
      handler.handle_message_event(event)
    end

    it 'regards some sequential spaces as a separator' do
      content = "<@#{bot_id}>   mecab   abc   def"
      content_holder[:value] = content
      expect(bot).to receive(:mecab_command).with('abc   def', respond)
      handler.handle_message_event(event)
    end

    it 'ignores texts in spoiler tags' do
      content = 'abc||def||ghi||jkl||mno'
      ignored_content = 'abc||||ghi||||mno'
      content_holder[:value] = content
      expect(bot).to receive(:detect).with(ignored_content, respond)
      handler.handle_message_event(event)
    end

    it 'ignores texts in spoiler tags over multiple lines' do
      content = "abc||def\nghi\njkl||mno"
      ignored_content = 'abc||||mno'
      content_holder[:value] = content
      expect(bot).to receive(:detect).with(ignored_content, respond)
      handler.handle_message_event(event)
    end

    it 'ignores quoted texts' do
      content = <<~EOS
        >KRIEG!
        > KRIEG!
        >  KRIEG!
        VERY VELL. THEN LET IT BE KRIEG.
      EOS
      ignored_content = <<~EOS
        >KRIEG!
        >
        >
        VERY VELL. THEN LET IT BE KRIEG.
      EOS
      content_holder[:value] = content
      expect(bot).to receive(:detect).with(ignored_content, respond)
      handler.handle_message_event(event)
    end

    it 'ignores quoted texts over multiple lines' do
      content = <<~EOS
        She says:
        >>> SEARCH
        AND
        DESTROY!
      EOS
      ignored_content = <<~EOS
        She says:
        >>>
      EOS
      content_holder[:value] = content
      expect(bot).to receive(:detect).with(ignored_content, respond)
      handler.handle_message_event(event)
    end

    it 'ignores code' do
      content = 'Let\'s enter `puts "hello world"`.'
      ignored_content = 'Let\'s enter ``.'
      content_holder[:value] = content
      expect(bot).to receive(:detect).with(ignored_content, respond)
      handler.handle_message_event(event)
    end

    it 'ignores code over multiple lines' do
      content = <<~EOS
        Let's enter:
        ```rb
        puts "hello world"
        ```
      EOS
      ignored_content = <<~EOS
        Let's enter:
        ``````
      EOS
      content_holder[:value] = content
      expect(bot).to receive(:detect).with(ignored_content, respond)
      handler.handle_message_event(event)
    end
  end

  describe '#handle_reaction_add_event' do
    let(:event) do
      instance_double(
        Discordrb::Events::ReactionAddEvent,
        message:,
        emoji:
      )
    end
    let(:message) do
      instance_double(
        Discordrb::Message,
        author: author_holder[:value]
      )
    end
    let(:author_holder) { { value: member_bot_me } }
    let(:emoji) do
      instance_double(
        Discordrb::Emoji,
        name: emoji_name_holder[:value]
      )
    end
    let(:emoji_name_holder) { { value: '❌' } }

    it 'does not call any method when reacted message is others' do
      author_holder[:value] = member_bot1
      handler.handle_reaction_add_event(event)
    end

    it 'calls `delete` method when the reaction is "❌"' do
      expect(bot).to receive(:delete)
      handler.handle_reaction_add_event(event)
    end

    it 'does not call any method when the reaction is different' do
      emoji_name_holder[:value] = '⭕'
      handler.handle_reaction_add_event(event)
    end
  end
end
