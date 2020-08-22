%w[
  verse_rule/generator
  verse_rule/repository_redis
  verse_rule/updater
  verse_rule/verse_rule
].each { |path| require path }
