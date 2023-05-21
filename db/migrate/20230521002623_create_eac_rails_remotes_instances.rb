# frozen_string_literal: true

class CreateEacRailsRemotesInstances < ActiveRecord::Migration[5.2]
  def change
    create_table :eac_rails_remotes_instances do |t|
      t.string :source
      t.string :entity
      t.string :code
      t.references :target, polymorphic: true
      t.text :data
      t.integer :export_status
      t.text :export_message

      t.timestamps null: false
    end
  end
end
