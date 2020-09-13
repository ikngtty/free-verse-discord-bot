# frozen_string_literal: true

require 'discordrb'
require 'dotenv/load'
require 'ikku'
require 'natto'
require 'redis'
require_relative './lib/bot'
require_relative './lib/discord_event_handler'
require_relative './lib/redis_wrapper'
require_relative './lib/verse_rule/generator'
require_relative './lib/verse_rule/repository_redis'

ENV_TOKEN = 'DISCORD_BOT_TOKEN'
token = ENV[ENV_TOKEN]
unless token
  puts "ERROR! The environment variable #{ENV_TOKEN} is not defined."
  exit 1
end

ENV_REDIS_URL = 'REDIS_URL'
unless ENV[ENV_REDIS_URL]
  puts "ERROR! The environment variable #{ENV_REDIS_URL} is not defined."
  exit 1
end

get_random = method(:rand)
get_today = Date.method(:today)
mecab = Natto::MeCab.new
get_ikku_reviewer = Ikku::Reviewer.method(:new)
bot_lib = Discordrb::Bot.new token: token

generate_rule = VerseRule::Generator.new(
  get_random: get_random,
  get_today: get_today
)
redis_wrapper = RedisWrapper.new(Redis.new)
rule_repository = VerseRule::RepositoryRedis.new(
  redis_client: redis_wrapper
)
bot = Bot.new(
  generate_rule: generate_rule,
  get_ikku_reviewer: get_ikku_reviewer,
  get_today: get_today,
  mecab: mecab,
  rule_repository: rule_repository
)
handler = DiscordEventHandler.new(
  bot: bot,
  discordrb_bot: bot_lib
)

bot_lib.ready do
  bot_lib.game = '俳句じゃないやつ検出'
end

bot_lib.message(&handler.method(:handle_message_event))
bot_lib.reaction_add(&handler.method(:handle_reaction_add_event))

bot_lib.run
