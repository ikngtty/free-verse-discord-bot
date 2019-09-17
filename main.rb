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

ENV_DEBUG_MODE = 'DEBUG_MODE'
debug_mode = %w[1 true].member? ENV[ENV_DEBUG_MODE]

bot = Discordrb::Bot.new token: token
basho = Ikku::Reviewer.new(rule: [3, 4, 5])
mecab = Natto::MeCab.new

bot.ready do
  bot.game = '俳句じゃないやつ検出'
end

bot.message do |event|
  author_name = event.author.username
  songs = basho.search(event.content)
  songs.each do |song|
    verses = song.phrases.map do |phrase|
      phrase.map(&:to_s).join
    end
    event.respond <<~EOF
      ┏━━━━━━━━━━━　**本日の一句**　━━━━━━━━━━━
      ┃
      ┃　　#{verses[0]}
      ┃
      ┃　　　　#{verses[1]}
      ┃
      ┃　　　　　　#{verses[2]}
      ┃
      ┃　　　　　　　　　　　　　　　　　　詠み手：#{author_name}
      ┃
      ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    EOF
  end
end

bot.mention do |event|
  command_format = "<@#{bot.profile.id}> %s"
  mecab_format = format(command_format, 'mecab')
  info_format = format(command_format, 'info')

  if event.content.start_with? mecab_format
    message = event.content.delete_prefix(mecab_format).lstrip
    event.respond "```\n#{mecab.parse(message)}\n```"
  elsif debug_mode and event.content.start_with? info_format
    server_names = bot.servers.map do |id, server|
      "<#{id}> #{server.name}"
    end.join("\n")
    event.respond "I'm in these servers:\n#{server_names}"
  end
end

bot.run
