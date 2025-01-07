# frozen_string_literal: true

class PlayerStat < ApplicationRecord
  belongs_to :player, dependent: :destroy
  belongs_to :team, dependent: :destroy
  belongs_to :match, dependent: :destroy

  validates_presence_of :goals
  validates_presence_of :assists
  validates_presence_of :own_goals
  validates :was_goalkeeper, inclusion: [true, false]
end
