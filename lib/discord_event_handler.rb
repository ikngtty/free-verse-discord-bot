# frozen_string_literal: true

class DiscordEventHandler
  def initialize(bot, discordrb_bot)
    @bot = bot
    @bot_lib = discordrb_bot
  end

  def handle_message_event(event)
    return if event.author.bot_account?

    match = command_regexp.match(event.content)
    if match
      captures = match.named_captures
      command = captures['command']
      args_text = captures['args']
      do_command(event, command, args_text)
    else
      detect(event)
    end
  end

  private

  def detect(event)
    @bot.detect(event.content).each do |result_message|
      event.respond(result_message)
    end
  end

  def do_command(event, command, args_text)
    result_messages =
      case command
      when 'mecab'
        @bot.mecab_command(args_text)
      when 'info'
        @bot.info_command
      else
        @bot.unknown_command
      end

    result_messages.each { |result| event.respond(result) }
  end

  def command_regexp
    id = @bot_lib.profile.id
    /\A (?: \< @#{id} \> | \< @!#{id} \>) \s* (?<command> \S+) \s* (?<args> .*) \Z/mx
  end
end
