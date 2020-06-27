# frozen_string_literal: true

# NOTE: "Ikku::Reviewer" is so long and "reviewer" is so ambiguous
# that we call it "basho", named after "Matsuo Basho".

class Bot
  def initialize(args)
    @bot_lib = args[:discordrb_bot]
    @rule_holder = args[:rule_holder]
    @get_basho = args[:get_ikku_reviewer]
    @mecab = args[:mecab]
    @debug_mode = args[:debug_mode]
  end

  def detect(message)
    result_messages = []

    rule_values = @rule_holder.current.values
    basho = @get_basho.call(rule: rule_values)
    songs = basho.search(message)
    songs.each do |song|
      verses = song.phrases.map do |phrase|
        phrase.map(&:to_s).join
      end
      result_messages << <<~EOD
        > #{verses[0]}
        > #{verses[1]}
        > #{verses[2]}
      EOD
    end

    result_messages.uniq
  end

  def mecab_command(message)
    ["```\n#{@mecab.parse(message)}\n```"]
  end

  def info_command
    return ['そう簡単に情報を渡すわけにはいかない。'] unless @debug_mode

    messages = []
    messages << "The current time is: #{DateTime.now}"
    messages << "The current rule is: #{@rule_holder.current}"

    server_names = @bot_lib.servers.map do |id, server|
      "<#{id}> #{server.name}"
    end.join("\n")
    messages << "I'm in these servers:\n#{server_names}"

    messages
  end

  def unknown_command
    ['ちょっと何言ってるか分かんないですｗ']
  end
end
