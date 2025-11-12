# frozen_string_literal: true

require "net/http"
require "uri"
require "json"

module Events
  class EventClient
    class MissingConfigurationError < StandardError; end

    def initialize(endpoint: Rails.configuration.x.event_gateway[:endpoint], api_key: Rails.configuration.x.event_gateway[:api_key])
      @endpoint = endpoint
      @api_key = api_key
    end

    def publish(subject:, payload:)
      raise MissingConfigurationError, "EVENT_GATEWAY_URL is not configured" if endpoint.blank?

      uri = URI.join(endpoint, "/events/#{subject}")
      request = Net::HTTP::Post.new(uri)
      request["Content-Type"] = "application/json"
      request["X-API-Key"] = api_key if api_key.present?
      request.body = payload.to_json

      response = http_client(uri).request(request)

      return true if response.code.to_i.between?(200, 299)

      Rails.logger.error(
        "Event gateway rejected payload",
        subject: subject,
        status: response.code,
        body: response.body
      )
      raise StandardError, "Event gateway rejected payload"
    end

    private

    attr_reader :endpoint, :api_key

    def http_client(uri)
      Net::HTTP.new(uri.hostname, uri.port).tap do |http|
        http.use_ssl = uri.scheme == "https"
        http.read_timeout = 5
        http.open_timeout = 2
      end
    end
  end
end
