# frozen_string_literal: true

require 'date'
require 'json'

require 'rspec'

require_relative '../lib/verse_rule'

RSpec.describe VerseRule do
  subject(:rule) { described_class.new(values: [5, 7, 4], created_at: today) }

  let(:today) { Date.new(1982, 12, 6) }

  it 'can interconvert between object and json text' do
    json = JSON.generate(rule)
    restored_rule = JSON.parse(json, create_additions: true)
    expect(restored_rule).to eq rule
  end
end
