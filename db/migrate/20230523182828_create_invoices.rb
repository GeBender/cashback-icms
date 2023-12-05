# frozen_string_literal: true

class CreateInvoices < ActiveRecord::Migration[7.0]
  def change
    create_table :invoices do |t|
      t.references :company, foreign_key: true
      t.string :key
      t.string :version
      t.string :emit_cnpj
      t.string :dest_document
      t.string :cUF
      t.string :cNF
      t.text :natOp
      t.string :mod
      t.string :serie
      t.string :nNF
      t.datetime :dhEmi
      t.integer :tpNF
      t.integer :idDest
      t.string :cMunFG
      t.integer :cancel, default: 0
      t.timestamps
    end
  end
end
