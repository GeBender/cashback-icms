# frozen_string_literal: true

class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.references :company, foreign_key: true
      t.bigint :cEAN
      t.bigint :cEANTrib
      t.string :NCM
      t.string :cProd
      t.string :xProd
      t.string :CEST
      t.string :uCom
      t.string :uTrib
      t.float :conversion_factor
      t.datetime :first
      t.datetime :last
      t.integer :cancel
      t.timestamps
    end
  end
end
