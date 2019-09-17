# frozen_string_literal: true

require 'discordrb'
require 'ikku'
require 'natto'

ENV_TOKEN = 'DISCORD_BOT_TOKEN'
token = ENV[ENV_TOKEN]
unless token
  puts "ERROR! The environment variable #{ENV_TOKEN} is not defined."
  exit 1
end

bot = Discordrb::Bot.new token: token
basho = Ikku::Reviewer.new(rule: [3, 4, 5])
mecab = Natto::MeCab.new

bot.message do |event|
  songs = basho.search(event.content)
  songs.each do |song|
    song_text = song.phrases.map do |phrase|
      phrase.map(&:to_s).join
    end.join("\n")
    event.respond "[Detection]\n#{song_text}"
  end
end

bot.mention do |event|
  command_format = "<@#{bot.profile.id}> %s"
  mecab_format = format(command_format, 'mecab')

  if event.content.start_with? mecab_format
    message = event.content.delete_prefix(mecab_format).lstrip
    event.respond "```\n#{mecab.parse(message)}\n```"
  end
end

bot.run
