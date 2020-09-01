# frozen_string_literal: true

require 'discordrb'
require 'rspec'

RSpec.shared_context 'with discordrb double' do
  let(:discordrb_bot) { instance_double(Discordrb::Bot, profile: bot_profile) }
  let(:bot_profile) { instance_double(Discordrb::Profile, id: bot_id ) }
  let(:bot_id) { 42 }
end
