# frozen_string_literal: true

class Round < ApplicationRecord
  belongs_to :championship
  has_many :matches, dependent: :destroy

  validates_presence_of :name
  validates_presence_of :round_date
end
