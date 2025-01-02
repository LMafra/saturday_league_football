# frozen_string_literal: true

class Championship < ApplicationRecord
  has_many :rounds

  validates_presence_of :name
end
