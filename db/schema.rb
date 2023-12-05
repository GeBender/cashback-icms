# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_06_07_181807) do
  create_table "aliquots", charset: "utf8mb4", force: :cascade do |t|
    t.date "start_date"
    t.string "ncm"
    t.float "mva"
    t.float "interstate_aliquot"
    t.float "internal_aliquot"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cfops", charset: "utf8mb4", force: :cascade do |t|
    t.string "description"
    t.string "cfop"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "companies", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "cnpj"
    t.string "ie"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ean_pmcs", charset: "utf8mb4", force: :cascade do |t|
    t.string "product"
    t.string "presentation"
    t.string "ean"
    t.float "pmc"
    t.float "conversion_fact"
    t.string "conversion_unit"
    t.string "cod_anvisa"
    t.date "start_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "company_id"
    t.string "event_id"
    t.string "cOrgao"
    t.string "chNFe"
    t.datetime "dhEvento"
    t.string "tpEvento"
    t.integer "nSeqEvento"
    t.string "descEvento"
    t.string "nProt"
    t.string "xJust"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_events_on_company_id"
  end

  create_table "invoices", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "company_id"
    t.string "key"
    t.string "version"
    t.string "emit_cnpj"
    t.string "dest_document"
    t.string "cUF"
    t.string "cNF"
    t.text "natOp"
    t.string "mod"
    t.string "serie"
    t.string "nNF"
    t.datetime "dhEmi"
    t.integer "tpNF"
    t.integer "idDest"
    t.string "cMunFG"
    t.integer "cancel", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_invoices_on_company_id"
  end

  create_table "items", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "company_id"
    t.bigint "cEAN"
    t.bigint "cEANTrib"
    t.string "NCM"
    t.string "cProd"
    t.string "xProd"
    t.string "CEST"
    t.string "uCom"
    t.string "uTrib"
    t.float "conversion_factor"
    t.datetime "first"
    t.datetime "last"
    t.integer "cancel"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_items_on_company_id"
  end

  create_table "movements", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "invoice_id"
    t.bigint "item_id"
    t.integer "type_move"
    t.integer "CST"
    t.string "CFOP"
    t.float "qTrib"
    t.float "vUnTrib"
    t.float "vFrete"
    t.float "vSeg"
    t.float "vDesc"
    t.float "vOutro"
    t.float "vIPI"
    t.float "pICMS"
    t.float "vBC"
    t.float "vICMS"
    t.float "pICMSST"
    t.float "vBCST"
    t.float "vICMSST"
    t.float "pST"
    t.float "vBCSTRet"
    t.float "vICMSSTRet"
    t.float "vFCPST"
    t.float "vFCPSTRet"
    t.datetime "invoice_date"
    t.float "pmc"
    t.float "aliquot"
    t.float "batch"
    t.string "invoice_key"
    t.string "cProd"
    t.string "xProd"
    t.integer "tpNF"
    t.bigint "cEANTrib"
    t.string "uTrib"
    t.string "uCom"
    t.float "qCom"
    t.float "vUnCom"
    t.float "vProd"
    t.string "doc_part"
    t.string "ie_part"
    t.string "uf_part"
    t.float "avarage_buy"
    t.float "profit_margin"
    t.float "pmc_margin"
    t.float "mva"
    t.string "cProdANVISA"
    t.integer "cancel", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_movements_on_invoice_id"
    t.index ["item_id"], name: "index_movements_on_item_id"
  end

  create_table "participants", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "company_id"
    t.string "document"
    t.string "IE"
    t.string "xNome"
    t.string "cMun"
    t.string "xMun"
    t.string "UF"
    t.string "CRT"
    t.string "indIEDest"
    t.datetime "first"
    t.datetime "last"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_participants_on_company_id"
  end

  add_foreign_key "events", "companies"
  add_foreign_key "invoices", "companies"
  add_foreign_key "items", "companies"
  add_foreign_key "movements", "invoices"
  add_foreign_key "movements", "items"
  add_foreign_key "participants", "companies"
end
