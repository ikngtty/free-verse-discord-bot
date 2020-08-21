# frozen_string_literal: true

# NOTE: "Ikku::Reviewer" is so long and "reviewer" is so ambiguous
# that we call it "basho", named after "Matsuo Basho".

require_relative 'verse_rule_updater'

class Bot
  def initialize(args)
    generate_rule = args.fetch(:generate_rule)
    @get_basho = args.fetch(:get_ikku_reviewer)
    get_today = args.fetch(:get_today)
    @mecab = args.fetch(:mecab)
    @rule_repository = args.fetch(:rule_repository)

    @rule_updater = VerseRuleUpdater.new(
      @rule_repository, generate_rule, get_today
    )
  end

  def detect(message)
    @rule_updater.exec_as_needed

    result_messages = []

    rule_values = @rule_repository.current.values
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

  def unknown_command
    ['ちょっと何言ってるか分かんないですｗ']
  end
end
