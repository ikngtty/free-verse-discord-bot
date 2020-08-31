# frozen_string_literal: true

class DiscordEventHandler
  def initialize(args)
    @bot = args.fetch(:bot)
    @bot_lib = args.fetch(:discordrb_bot)
  end

  def handle_message_event(event)
    return if event.author.bot_account?
    return if event.server.nil?

    bot_id = @bot_lib.profile.id
    member = event.server.member(bot_id)
    return if member.nil?

    respond = event.method(:respond)

    managed_role = member.roles.find(&:managed?)
    match = command_regexp(bot_id, managed_role.id).match(event.content)
    if match
      captures = match.named_captures
      command = captures['command']
      args_text = captures['args']
      case command
      when 'mecab'
        @bot.mecab_command(args_text, respond)
      else
        @bot.unknown_command(respond)
      end
    else
      @bot.detect(event.content, respond)
    end
  end

  private

  def command_regexp(bot_id, managed_role_id)
    /\A (?: \< @#{bot_id} \> | \< @!#{bot_id} \> | \< @&#{managed_role_id} \>) \s* (?<command> \S+) \s* (?<args> .*) \Z/mx
  end
end
