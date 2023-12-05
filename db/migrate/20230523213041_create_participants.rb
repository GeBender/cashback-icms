# frozen_string_literal: true

class CreateParticipants < ActiveRecord::Migration[7.0]
  def change
    create_table :participants do |t|
      t.references :company, foreign_key: true
      t.string :document
      t.string :IE
      t.string :xNome
      t.string :cMun
      t.string :xMun
      t.string :UF
      t.string :CRT
      t.string :indIEDest
      t.datetime :first
      t.datetime :last
      t.timestamps
    end
  end
end
