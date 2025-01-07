# frozen_string_literal: true

FactoryBot.define do
  factory :team do
    name { Faker::Sports::Football.team }
  end
end
