# frozen_string_literal: true

# NOTE: "Ikku::Reviewer" is so long and "reviewer" is so ambiguous
# that we call it "basho", named after "Matsuo Basho".

require_relative 'verse_rule/updater'

class Bot
  def initialize(args)
    generate_rule = args.fetch(:generate_rule)
    @get_basho = args.fetch(:get_ikku_reviewer)
    get_today = args.fetch(:get_today)
    @mecab = args.fetch(:mecab)
    @rule_repository = args.fetch(:rule_repository)

    @rule_updater = VerseRule::Updater.new(
      repository: @rule_repository,
      generate_rule: generate_rule,
      get_today: get_today
    )
  end

  def detect(message, respond)
    @rule_updater.exec_as_needed

    rule_values = @rule_repository.current.values
    basho = @get_basho.call(rule: rule_values)
    songs = basho.search(message)
    result_messages = songs.map do |song|
      verses = song.phrases.map(&:join)
      <<~EOD
        > #{verses[0]}
        > #{verses[1]}
        > #{verses[2]}
      EOD
    end

    result_messages.uniq.each do |result|
      respond.call(result)
    end
  end

  def mecab_command(message, respond)
    respond.call("```\n#{@mecab.parse(message)}\n```")
  end

  def unknown_command(respond)
    respond.call('ちょっと何言ってるか分かんないですｗ')
  end
end
