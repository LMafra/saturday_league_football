# frozen_string_literal: true

class CreatePlayerTeam < ActiveRecord::Migration[8.0]
  def change
    create_table :player_teams do |t|
      t.references :player, index: true, foreign_key: true
      t.references :team, index: true, foreign_key: true
      t.timestamps
    end
  end
end
