# frozen_string_literal: true

class CreateEanPmcs < ActiveRecord::Migration[7.0]
  def change
    create_table :ean_pmcs do |t|
      t.string :product
      t.string :presentation
      t.string :ean
      t.float :pmc
      t.float :conversion_fact
      t.string :conversion_unit
      t.string :cod_anvisa
      t.date :start_date
      t.timestamps
    end
  end
end
