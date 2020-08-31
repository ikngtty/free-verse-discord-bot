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
    message_text = event.content
    result = analyze(message_text, bot_id, managed_role.id)
    if result.command?
      case result.command
      when 'mecab'
        @bot.mecab_command(result.args_text, respond)
      else
        @bot.unknown_command(respond)
      end
    else
      @bot.detect(message_text, respond)
    end
  end

  AnalyzeResult = Struct.new(
    :command?,
    :command,
    :args_text,
    keyword_init: true
  )
  private_constant :AnalyzeResult

  private

  def analyze(message_text, bot_id, managed_role_id)
    re = /\A (?: \< @#{bot_id} \> | \< @!#{bot_id} \> | \< @&#{managed_role_id} \>) \s* (?<command> \S+) \s* (?<args> .*) \Z/mx
    match = re.match(message_text)
    return AnalyzeResult.new(command?: false) if match.nil?

    captures = match.named_captures
    AnalyzeResult.new(
      command?: true,
      command: captures['command'],
      args_text: captures['args']
    )
  end
end
