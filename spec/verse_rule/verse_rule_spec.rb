# frozen_string_literal: true

require 'date'
require 'json'

require 'rspec'

require_relative '../shared_context/with_fixed_today'
require_relative '../../lib/verse_rule/verse_rule'

RSpec.describe VerseRule do
  subject(:rule) { described_class.new(values: [5, 7, 4], created_at: @today) }

  include_context 'with fixed today'

  it 'can interconvert between object and json text' do
    json = JSON.generate(rule)
    restored_rule = JSON.parse(json, create_additions: true)
    expect(restored_rule).to eq rule
  end
end
