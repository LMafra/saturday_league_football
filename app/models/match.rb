# frozen_string_literal: true

require "securerandom"

class Match < ApplicationRecord
  belongs_to :round
  belongs_to :team_1, class_name: 'Team', foreign_key: 'team_1_id'
  belongs_to :team_2, class_name: 'Team', foreign_key: 'team_2_id'
  belongs_to :winning_team, class_name: 'Team', foreign_key: 'winning_team_id', optional: true

  validates :name, presence: true
  validates :platform_uid, presence: true
  validates :team_1, :team_2, presence: true

  before_validation :assign_platform_uid, on: :create

  after_commit :enqueue_match_scheduled_event, on: %i[create update]

  private

  def assign_platform_uid
    self.platform_uid ||= SecureRandom.uuid
  end

  def enqueue_match_scheduled_event
    return if team_1.blank? || team_2.blank?

    Events::PublishMatchScheduledJob.perform_later(id)
  end
end
