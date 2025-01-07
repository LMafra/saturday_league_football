# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlayerTeam, type: :model do
  subject { FactoryBot.create(:player_team, :with_team, :with_player) }

  it { should belong_to :player }
  it { should belong_to :team }
  it { should be_valid }
end
