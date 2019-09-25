# frozen_string_literal: true

# NOTE: "Ikku::Reviewer" is so long and "reviewr" is so ambiguous
# that we call it "basho", named after "Matsuo Basho".

class FreeVerseBot
  def initialize(args)
    @bot = args[:discordrb_bot]
    @get_rule = args[:get_rule]
    @get_basho = args[:get_ikku_reviewer]
    @mecab = args[:mecab]
    @debug_mode = args[:debug_mode]
  end

  def handle_message_event(event)
    return if event.author.bot_account?

    do_command(event) if may_be_command?(event)
    detect(event)
  end

  private

  def detect(event)
    author_name = event.author.username
    rule = @get_rule.call
    basho = @get_basho.call(rule: rule)
    songs = basho.search(event.content)
    songs.each do |song|
      verses = song.phrases.map do |phrase|
        phrase.map(&:to_s).join
      end
      event.respond <<~EOD
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
      EOD
    end
  end

  def do_command(event)
    command_prefix_format = "#{at_sign_to_me} %s"
    mecab_prefix = format(command_prefix_format, 'mecab')
    info_prefix = format(command_prefix_format, 'info')

    if event.content.start_with?(mecab_prefix)
      message = event.content.delete_prefix(mecab_prefix).lstrip
      mecab_command(message, event)
    elsif @debug_mode && event.content.start_with?(info_prefix)
      info_command(event)
    end
  end

  def mecab_command(message, event)
    event.respond "```\n#{@mecab.parse(message)}\n```"
  end

  def info_command(event)
    server_names = @bot.servers.map do |id, server|
      "<#{id}> #{server.name}"
    end.join("\n")
    event.respond "I'm in these servers:\n#{server_names}"
  end

  def may_be_command?(event)
    event.content.start_with?(at_sign_to_me)
  end

  def at_sign_to_me
    "<@#{@bot.profile.id}>"
  end
end
