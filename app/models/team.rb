# frozen_string_literal: true

class Team < ApplicationRecord
  has_many :player_teams, dependent: :destroy
  has_many :players, through: :player_teams

  accepts_nested_attributes_for :player_teams, allow_destroy: true

  validates_presence_of :name
end
