# frozen_string_literal: true

class Player < ApplicationRecord
  has_many :player_stats, dependent: :destroy
  has_many :player_teams, dependent: :destroy
  accepts_nested_attributes_for :player_teams, allow_destroy: true
  has_many :teams, through: :player_teams

  validates_presence_of :name
end
