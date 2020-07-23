# frozen_string_literal: true

require 'discordrb'
require 'dotenv/load'

ENV_TOKEN = 'DISCORD_BOT_TOKEN'
token = ENV[ENV_TOKEN]
unless token
  puts "ERROR! The environment variable #{ENV_TOKEN} is not defined."
  exit 1
end

puts '-- Inspect servers --'
servers_json = Discordrb::API::User.servers("Bot #{token}")
begin
  servers = JSON.parse(servers_json)
  puts "joining #{servers.length} servers:"
  servers.each do |server|
    puts "<#{server['id']}> #{server['name']}"
  end
rescue JSON::ParserError
  puts servers_json
end
