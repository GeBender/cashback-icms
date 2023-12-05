# frozen_string_literal: true

class CreateAliquots < ActiveRecord::Migration[7.0]
  def change
    create_table :aliquots do |t|
      t.date :start_date
      t.string :ncm
      t.float :mva
      t.float :interstate_aliquot
      t.float :internal_aliquot

      t.timestamps
    end
  end
end
