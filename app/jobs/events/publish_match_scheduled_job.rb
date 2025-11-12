# frozen_string_literal: true

require "securerandom"

module Events
  class PublishMatchScheduledJob < ApplicationJob
    queue_as :default

    retry_on Events::EventClient::MissingConfigurationError, wait: :exponentially_longer, attempts: 3

    def perform(match_id)
      match = Match.includes(round: :championship, team_1: :players, team_2: :players).find(match_id)

      return if match.team_1.blank? || match.team_2.blank?

      client.publish(
        subject: "scheduling.match.scheduled.v1",
        payload: build_payload(match)
      )
    end

    private

    def client
      @client ||= Events::EventClient.new
    end

    def build_payload(match)
      round = match.round
      championship = round&.championship

      {
        eventId: SecureRandom.uuid,
        schemaVersion: "v1",
        occurredAt: Time.current.iso8601,
        source: "saturday-league-api",
        payload: {
          matchId: match.platform_uid,
          externalRefs: [
            { system: "saturday-league-api", identifier: match.id.to_s }
          ],
          competition: championship_payload(championship),
          round: round_payload(round),
          scheduledAt: (round&.round_date || match.created_at).iso8601,
          venue: {
            name: championship.respond_to?(:venue) && championship.venue.present? ? championship.venue : "TBD"
          },
          homeTeam: team_payload(match.team_1),
          awayTeam: team_payload(match.team_2)
        }
      }
    end

    def championship_payload(championship)
      return { id: "unknown", name: "Friendly" } if championship.blank?

      payload = {
        id: championship.id.to_s,
        name: championship.name
      }
      payload[:description] = championship.description if championship.respond_to?(:description) && championship.description.present?
      payload
    end

    def round_payload(round)
      return { name: "Unassigned" } if round.blank?

      payload = { name: round.name }
      payload[:number] = round.number if round.respond_to?(:number) && round.number.present?
      payload
    end

    def team_payload(team)
      {
        id: team.id.to_s,
        name: team.name,
        score: 0
      }
    end
  end
end
