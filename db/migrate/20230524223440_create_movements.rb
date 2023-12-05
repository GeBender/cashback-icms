class CreateMovements < ActiveRecord::Migration[7.0]
  def change
    create_table :movements do |t|
      t.references :invoice, foreign_key: true
      t.references :item, foreign_key: true
      t.integer :type_move
      t.integer :CST
      t.string :CFOP
      t.float :qTrib
      t.float :vUnTrib
      t.float :vFrete
      t.float :vSeg
      t.float :vDesc
      t.float :vOutro
      t.float :vIPI
      t.float :pICMS
      t.float :vBC
      t.float :vICMS
      t.float :pICMSST
      t.float :vBCST
      t.float :vICMSST
      t.float :pST
      t.float :vBCSTRet
      t.float :vICMSSTRet
      t.float :vFCPST
      t.float :vFCPSTRet
      t.datetime :invoice_date
      t.float :pmc
      t.float :aliquot
      t.float :batch
      t.string :invoice_key
      t.string :cProd
      t.string :xProd
      t.integer :tpNF
      t.bigint :cEANTrib
      t.string :uTrib
      t.string :uCom
      t.float :qCom
      t.float :vUnCom
      t.float :vProd
      t.string :doc_part
      t.string :ie_part
      t.string :uf_part
      t.float :avarage_buy
      t.float :profit_margin
      t.float :pmc_margin
      t.float :mva
      t.string :cProdANVISA
      t.integer :cancel, default: 0
      t.timestamps
    end
  end
end
