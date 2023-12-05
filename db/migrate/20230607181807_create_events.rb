# frozen_string_literal: true

#
# == CreateMEvents
class CreateEvents < ActiveRecord::Migration[7.0]
  # rubocop:disable Metrics/MethodLength
  def change
    create_table :events do |t|
      t.references :company, foreign_key: true
      t.string :event_id
      t.string :cOrgao
      t.string :chNFe
      t.datetime :dhEvento
      t.string :tpEvento
      t.integer :nSeqEvento
      t.string :descEvento
      t.string :nProt
      t.string :xJust
      t.timestamps
    end
  end
  # rubocop:enable Metrics/MethodLength
end
