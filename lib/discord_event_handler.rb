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
      message = event.content
      respond_func = event.method(:respond)
      @bot.detect(message, respond_func)
    end
  end

  private

  def do_command(event)
    content = event.content
    respond_func = event.method(:respond)

    command_prefix_format = "#{at_sign_to_me} %s"
    mecab_prefix = format(command_prefix_format, 'mecab')
    info_prefix = format(command_prefix_format, 'info')

    if content.start_with?(mecab_prefix)
      message = content.delete_prefix(mecab_prefix).lstrip
      @bot.mecab_command(message, respond_func)
    elsif content.start_with?(info_prefix)
      @bot.info_command(respond_func)
    end
  end

  def may_be_command?(event)
    event.content.start_with?(at_sign_to_me)
  end

  def at_sign_to_me
    "<@#{@bot_lib.profile.id}>"
  end
end
