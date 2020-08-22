# frozen_string_literal: true

require 'rspec'

RSpec.shared_context 'with fixed today' do
  let(:get_today) { -> { @today } }

  def go_to_tommorow
    @today += 1
  end

  before do
    stub_const('BASE_DAY', Date.new(1982, 12, 6))
    @today = BASE_DAY
  end
end
