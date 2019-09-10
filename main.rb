# frozen_string_literal: true

require 'discordrb'
require 'ikku'

ENV_TOKEN = 'DISCORD_BOT_TOKEN'
token = ENV[ENV_TOKEN]
unless token
  puts "ERROR! The environment variable #{ENV_TOKEN} is not defined."
  exit 1
end

bot = Discordrb::Bot.new token: token
basho = Ikku::Reviewer.new(rule: [3, 4, 5])

bot.message do |event|
  songs = basho.search(event.content)
  songs.each do |song|
    text = song.phrases.map do |phrase|
      phrase.map(&:to_s).join(' ')
    end.join("\n")
    event.respond text
  end
end

bot.run
