# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Team, type: :model do
  subject { FactoryBot.create(:team) }

  it { should have_many :player_teams }
  it { should have_many(:players).through(:player_teams) }
  it { should validate_presence_of :name }
  it { should be_valid }
end
