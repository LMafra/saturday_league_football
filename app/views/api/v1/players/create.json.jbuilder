# frozen_string_literal: true

if @player.persisted?
  json.status :created
  json.data do
    json.partial! 'api/v1/players/player', resource: @player
  end
else
  json.status :unprocessable_entity
  json.errors @player.errors.full_messages
end
