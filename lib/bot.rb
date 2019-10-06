# frozen_string_literal: true

# NOTE: "Ikku::Reviewer" is so long and "reviewr" is so ambiguous
# that we call it "basho", named after "Matsuo Basho".

class Bot
  def initialize(args)
    @bot_lib = args[:discordrb_bot]
    @get_rule = args[:get_rule]
    @get_basho = args[:get_ikku_reviewer]
    @mecab = args[:mecab]
    @debug_mode = args[:debug_mode]
  end

  def detect(message, respond_func)
    rule = @get_rule.call
    basho = @get_basho.call(rule: rule)
    songs = basho.search(message)
    songs.each do |song|
      verses = song.phrases.map do |phrase|
        phrase.map(&:to_s).join
      end
      respond_func.call <<~EOD
        > #{verses[0]}
        > #{verses[1]}
        > #{verses[2]}
      EOD
    end
  end

  def mecab_command(message, respond_func)
    respond_func.call("```\n#{@mecab.parse(message)}\n```")
  end

  def info_command(respond_func)
    return unless @debug_mode

    respond_func.call("The current time is: #{DateTime.now}")
    respond_func.call("The current rule is: #{@get_rule.call}")

    server_names = @bot_lib.servers.map do |id, server|
      "<#{id}> #{server.name}"
    end.join("\n")
    respond_func.call("I'm in these servers:\n#{server_names}")
  end
end
