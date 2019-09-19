# frozen_string_literal: true

require 'discordrb'
require 'ikku'
require 'natto'
require_relative './lib/free_verse_bot'

ENV_TOKEN = 'DISCORD_BOT_TOKEN'
token = ENV[ENV_TOKEN]
unless token
  puts "ERROR! The environment variable #{ENV_TOKEN} is not defined."
  exit 1
end

ENV_DEBUG_MODE = 'DEBUG_MODE'
debug_mode = %w[1 true].member? ENV[ENV_DEBUG_MODE]

bot = Discordrb::Bot.new token: token
basho = Ikku::Reviewer.new(rule: [3, 4, 5])
mecab = Natto::MeCab.new
free_verse_bot = FreeVerseBot.new(
  discordrb_bot: bot,
  ikku_reviewer: basho,
  mecab: mecab,
  debug_mode: debug_mode
)

bot.ready do
  bot.game = '俳句じゃないやつ検出'
end

bot.message(&free_verse_bot.method(:handle_message_event))
bot.mention(&free_verse_bot.method(:handle_mention_event))

bot.run
