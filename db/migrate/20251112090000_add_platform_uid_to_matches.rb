# frozen_string_literal: true

class AddPlatformUidToMatches < ActiveRecord::Migration[7.2]
  def change
    enable_extension "pgcrypto" unless extension_enabled?("pgcrypto")

    add_column :matches, :platform_uid, :uuid

    reversible do |dir|
      dir.up do
        execute <<~SQL.squish
          UPDATE matches
          SET platform_uid = gen_random_uuid()
          WHERE platform_uid IS NULL;
        SQL
      end
    end

    change_column_null :matches, :platform_uid, false
    add_index :matches, :platform_uid, unique: true
  end
end
