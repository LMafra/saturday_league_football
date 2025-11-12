# frozen_string_literal: true

Rails.configuration.x.event_gateway = {
  endpoint: ENV.fetch("EVENT_GATEWAY_URL", nil),
  api_key: ENV.fetch("EVENT_GATEWAY_API_KEY", nil)
}.freeze
