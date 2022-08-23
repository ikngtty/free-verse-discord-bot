# frozen_string_literal: true

require 'discordrb'
require 'rspec'

require_relative 'with_discordrb_double'

RSpec.shared_context 'with server double' do
  include_context 'with discordrb double'

  let(:server) do
    val = instance_double(
      Discordrb::Server,
      members: all_members
    )
    all_members.each do |member|
      allow(val).to receive(:member) { member.id }.and_return(member)
    end
    val
  end

  let(:all_members) { [member1, member2, member3, member_bot1, member_bot_me] }
  let(:member1) do
    instance_double(
      Discordrb::Member, id: 10, bot_account?: false,
                         roles: [role1]
    )
  end
  let(:member2) do
    instance_double(
      Discordrb::Member, id: 20, bot_account?: false,
                         roles: [role1, role2]
    )
  end
  let(:member3) do
    instance_double(
      Discordrb::Member, id: 30, bot_account?: false,
                         roles: [role1, role2, role3]
    )
  end
  let(:member_bot1) do
    instance_double(
      Discordrb::Member, id: 15, bot_account?: true,
                         roles: [role1, role_bot1]
    )
  end
  let(:member_bot_me) do
    instance_double(
      Discordrb::Member, id: bot_id, bot_account?: true,
                         roles: [role1, role_bot_me]
    )
  end

  let(:role1) { instance_double(Discordrb::Role, id: 100, managed?: false) }
  let(:role2) { instance_double(Discordrb::Role, id: 200, managed?: false) }
  let(:role3) { instance_double(Discordrb::Role, id: 300, managed?: false) }
  let(:role_bot1) { instance_double(Discordrb::Role, id: 150, managed?: true) }
  let(:role_bot_me) { instance_double(Discordrb::Role, id: 420, managed?: true) }
end
