# frozen_string_literal: true

class CreateMatches < ActiveRecord::Migration[8.0]
  def change
    create_table :matches do |t|
      t.string :name
      t.references :round, foreign_key: true
      t.references :team_1, foreign_key: { to_table: :teams }
      t.references :team_2, foreign_key: { to_table: :teams }
      t.references :winning_team, foreign_key: { to_table: :teams }, null: true
      t.boolean :draw
      t.timestamps
    end
  end
end
