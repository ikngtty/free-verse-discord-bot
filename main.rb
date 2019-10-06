# frozen_string_literal: true

require 'discordrb'
require 'ikku'
require 'natto'
require_relative './lib/bot'
require_relative './lib/discord_event_handler'
require_relative './lib/rule_generator'

ENV_TOKEN = 'DISCORD_BOT_TOKEN'
token = ENV[ENV_TOKEN]
unless token
  puts "ERROR! The environment variable #{ENV_TOKEN} is not defined."
  exit 1
end

ENV_DEBUG_MODE = 'DEBUG_MODE'
debug_mode = %w[1 true].member? ENV[ENV_DEBUG_MODE]

bot_lib = Discordrb::Bot.new token: token
mecab = Natto::MeCab.new
bot = Bot.new(
  discordrb_bot: bot_lib,
  get_rule: RuleGenerator.new(method(:rand), Date.method(:today)),
  get_ikku_reviewer: Ikku::Reviewer.method(:new),
  mecab: mecab,
  debug_mode: debug_mode
)
handler = DiscordEventHandler.new(bot, bot_lib)

bot_lib.ready do
  bot_lib.game = '俳句じゃないやつ検出'
end

bot_lib.message(&handler.method(:handle_message_event))

bot_lib.run
