# frozen_string_literal: true

FactoryBot.define do
  factory :player_stat do
    goals { Faker::Number.between(from: 0, to: 2) }
    own_goals { Faker::Number.between(from: 0, to: 2) }
    assists { Faker::Number.between(from: 0, to: 2) }
    was_goalkeeper { [true, false].sample }

    trait :with_player do
      player { create(:player) }
    end

    trait :with_team do
      team { create(:team) }
    end

    trait :with_match do
      match { create(:match, :with_round, :with_team_1, :with_team_2) }
    end
  end
end
