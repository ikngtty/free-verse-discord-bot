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
        @bot.mecab_command(result.rest, respond)
      else
        @bot.unknown_command(respond)
      end
    else
      @bot.detect(result.rest, respond)
    end
  end

  def handle_reaction_add_event(event)
    return unless event.message.author.id == @bot_lib.profile.id

    @bot.delete(event.message, :delete.to_proc) if event.emoji.name == '❌'
  end

  AnalyzeResult = Struct.new(
    :command?,
    :command,
    :rest,
    keyword_init: true
  )
  private_constant :AnalyzeResult

  private

  def analyze(message_text, bot_id, managed_role_id)

    quote_multiline_regexp = / ^ >>> \s .* \z /mx
    message_text = message_text.gsub(quote_multiline_regexp, ">>>\n")

    quote_regexp = / ^ > \s .* $ /x
    message_text = message_text.gsub(quote_regexp, '>')

    spoiler_regexp = / \|\| .+? \|\| /mx
    message_text = message_text.gsub(spoiler_regexp, '||||')

    command_regexp = /\A (?:
      \< @#{bot_id} \> |
      \< @!#{bot_id} \> |
      \< @&#{managed_role_id} \>
      )

      \s*

      (?<command> \S+)

      \s*

      (?<rest> .*) \Z/mx
    match = command_regexp.match(message_text)
    return AnalyzeResult.new(command?: false, rest: message_text) if match.nil?

    captures = match.named_captures
    AnalyzeResult.new(
      command?: true,
      command: captures['command'],
      rest: captures['rest']
    )
  end
end
