# frozen_string_literal: true

FactoryBot.define do
  factory :round do
    name { "#{Faker::Number.decimal_part(digits: 2)} Rodada" }
    round_date { Faker::Date.on_day_of_week_between(day: :saturday, from: '2025-01-01', to: '2025-12-31') }

    trait :with_championship do
      championship { FactoryBot.create(:championship) }
    end
  end
end
