# frozen_string_literal: true

# == CreateCfops
#
# Create cfops table migration
#
class CreateCfops < ActiveRecord::Migration[7.0]
  def change
    create_table :cfops do |t|
      t.string :description
      t.string :cfop
      t.timestamps
    end
  end
end
