# frozen_string_literal: true

class DiscordEventHandler
  def initialize(bot, discordrb_bot)
    @bot = bot
    @bot_lib = discordrb_bot
  end

  def handle_message_event(event)
    return if event.author.bot_account?

    if may_be_command?(event)
      do_command(event)
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

  def do_command(event)
    command_prefix_format = "#{at_sign_to_me} %s"
    mecab_prefix = format(command_prefix_format, 'mecab')
    info_prefix = format(command_prefix_format, 'info')

    content = event.content
    result_messages =
      if content.start_with?(mecab_prefix)
        message = content.delete_prefix(mecab_prefix).lstrip
        @bot.mecab_command(message)
      elsif content.start_with?(info_prefix)
        @bot.info_command
      else
        []
      end

    result_messages.each { |result| event.respond(result) }
  end

  def may_be_command?(event)
    event.content.start_with?(at_sign_to_me)
  end

  def at_sign_to_me
    "<@#{@bot_lib.profile.id}>"
  end
end
