# frozen_string_literal: true

FactoryBot.define do
  factory :championship do
    name { Faker::Sports::Football.competition }
  end
end
