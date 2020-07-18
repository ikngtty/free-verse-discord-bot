# frozen_string_literal: true

require 'discordrb'
require 'ikku'
require 'natto'
require_relative './lib/bot'
require_relative './lib/discord_event_handler'
require_relative './lib/verse_rule_generator'
require_relative './lib/verse_rule_repository_memory'

ENV_TOKEN = 'DISCORD_BOT_TOKEN'
token = ENV[ENV_TOKEN]
unless token
  puts "ERROR! The environment variable #{ENV_TOKEN} is not defined."
  exit 1
end

ENV_DEBUG_MODE = 'DEBUG_MODE'
debug_mode = %w[1 true].member? ENV[ENV_DEBUG_MODE]

get_rand = method(:rand)
get_today = Date.method(:today)
mecab = Natto::MeCab.new
get_ikku_reviewer = Ikku::Reviewer.method(:new)
bot_lib = Discordrb::Bot.new token: token

generate_rule = VerseRuleGenerator.new(get_rand, get_today)
rule_repository = VerseRuleRepositoryMemory.new
bot = Bot.new(
  discordrb_bot: bot_lib,
  debug_mode: debug_mode,
  generate_rule: generate_rule,
  get_ikku_reviewer: get_ikku_reviewer,
  get_today: get_today,
  mecab: mecab,
  rule_repository: rule_repository
)
handler = DiscordEventHandler.new(bot, bot_lib)

bot_lib.ready do
  bot_lib.game = '俳句じゃないやつ検出'
end

bot_lib.message(&handler.method(:handle_message_event))

bot_lib.run
