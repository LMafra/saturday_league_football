# frozen_string_literal: true

class CreatePlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :players do |t|
      t.string :name
      t.timestamps
    end
  end
end
