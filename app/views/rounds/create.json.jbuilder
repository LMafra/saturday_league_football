# frozen_string_literal: true

if @round.persisted?
  json.status :created
  json.data do
    json.partial! 'rounds/round', resource: @round
  end
else
  json.status :unprocessable_entity
  json.errors @round.errors.full_messages
end
