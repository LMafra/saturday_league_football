# frozen_string_literal: true

class CreatePlayerStats < ActiveRecord::Migration[8.0]
  def change
    create_table :player_stats do |t|
      t.integer :goals
      t.integer :own_goals
      t.integer :assists
      t.boolean :was_goalkeeper
      t.references :player, foreign_key: true
      t.references :team, foreign_key: true
      t.references :match, foreign_key: true
      t.timestamps
    end
  end
end
