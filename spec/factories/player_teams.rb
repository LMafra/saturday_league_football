FactoryBot.define do
  factory :player_team do
    trait :with_team do
      team { FactoryBot.create(:team) }
    end
    trait :with_player do
      player { FactoryBot.create(:player) }
    end
  end
end
