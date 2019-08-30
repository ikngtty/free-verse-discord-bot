# frozen_string_literal: true

require 'discordrb'

ENV_TOKEN = 'DISCORD_BOT_TOKEN'
token = ENV[ENV_TOKEN]
unless token
  puts "ERROR! The environment variable #{ENV_TOKEN} is not defined."
  exit 1
end

bot = Discordrb::Bot.new token: token

bot.message(with_text: 'Ping!') do |event|
  event.respond 'Pong!'
end

bot.run
