# frozen_string_literal: true

class CreateRounds < ActiveRecord::Migration[8.0]
  def change
    create_table :rounds do |t|
      t.string :name
      t.date :round_date
      t.references :championship, foreign_key: true
      t.timestamps
    end
  end
end
