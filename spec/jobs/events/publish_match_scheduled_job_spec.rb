# frozen_string_literal: true

require "rails_helper"

RSpec.describe Events::PublishMatchScheduledJob, type: :job do
  let(:client) { instance_double(Events::EventClient, publish: true) }
  let(:round) { create(:round, :with_championship, round_date: Time.zone.parse("2025-11-12")) }
  let(:team_1) { create(:team, round: round) }
  let(:team_2) { create(:team, round: round) }
  let(:match) { create(:match, round: round, team_1: team_1, team_2: team_2) }

  before do
    allow(Events::EventClient).to receive(:new).and_return(client)
    allow(SecureRandom).to receive(:uuid).and_return("event-uuid")
  end

  it "publishes a match scheduled event when teams exist" do
    described_class.perform_now(match.id)

    expect(client).to have_received(:publish).with(hash_including(subject: "scheduling.match.scheduled.v1"))
  end

  it "skips publishing when teams are missing" do
    match.update!(team_2: nil)

    described_class.perform_now(match.id)

    expect(client).not_to have_received(:publish)
  end
end
