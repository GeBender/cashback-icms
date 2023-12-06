# frozen_string_literal: true

# == Movement
#
# All Movement logical things
#
class Movement < ApplicationRecord
  include XmlLoaders::MovementLoader
  include Renderers::MovementRenderer
  include Definers::MovementDefiner
  include Definers::CodOperStDefiner

  attr_accessor :last_estoque,
                :last_saldo_bc,
                :last_icms_prop,
                :last_saldo_unit,
                :sum_ressarc,
                :sum_compl,
                :month,
                :buys,
                :sales

  default_scope { order(invoice_date: :asc).order(type_move: :asc).order(id: :asc) }
  enum type_move: { buy: 0, sale: 1, initial: 2, final: 3 }

  belongs_to :invoice
  belongs_to :item

  scope :from_client, ->(client_ie) { joins(invoice: :company).where(companies: { ie: client_ie }) }
  scope :from_item, ->(item_id) { where('item_id = ?', item_id) }
  scope :uncanceled, -> { joins(:item).where('items.cancel = 0').where('(movements.cancel = 0)') }
  scope :has_margin, -> { where('profit_margin IS NOT NULL') }
  scope :with_ean, -> { where('cEANTrib > 0') }
  scope :with_pmc, -> { where('pmc > 0') }
  scope :without_pmc, -> { where('pmc IS NULL') }
  scope :with_aliquot, -> { where('aliquot > 0') }
  scope :buys, -> { where(type_move: 0) }
  scope :sales, -> { where(type_move: 1) }
  scope :filtering, ->(filter_field, filter) { where("#{filter_field} = ?", filter) }
  scope :beginning, ->(start_date) { where('invoice_date > ?', start_date.to_date - 1.day) }
  scope :ending, ->(end_date) { where('invoice_date < ?', end_date.to_date + 1.day) }

  def set_margins_and_averages
    calc_average_sale
    calc_profit_margin
    calc_pmc_margin
  end

  def calc_average_sale
    to_average = Movement.sales
                         .where('id > ?', id)
                         .from_item(item_id)
                         .limit(10).to_a

    sum_prices = 0
    to_average.each do |movement|
      sum_prices += movement.vUnTrib
    end
    return 0 unless to_average.any?

    self.average_sale = (sum_prices / to_average.size)
  end

  def calc_profit_margin
    return 0 if sale? || average_sale.to_f.zero? || vUnTrib.zero?

    calc_value = vUnTrib / fat_conv
    self.profit_margin = ((average_sale - calc_value) / calc_value) * 100
  end

  def calc_pmc_margin
    return 0 if sale? || average_sale.to_f.zero? || pmc.to_f.zero?

    pmc_batch = (pmc * 0.9) / fat_conv
    return if pmc_batch.to_f.zero?

    self.pmc_margin = ((average_sale - pmc_batch) / pmc_batch) * 100
  end

  def rescue(item_id, ean)
    self.item_id = item_id
    self.cEANTrib = ean
    self.pmc = EanPmc.find_pmc(cEANTrib, invoice_date)

    save
  end

  def entry? = (initial? || buy?)

  def outside_issuer?
    return false unless uf_part

    uf_part != 'MS'
  end

  def inside_issuer?
    !outside_issuer?
  end

  def state_taxpayer_issuer?
    return false unless ie_part

    ie_part[0..1] == '28'
  end

  def fat_conv = (batch.to_f.positive? ? batch : 1)

  def bc_pmc
    return unless pmc?

    (pmc * 0.9 * def_qtd_entrada) / fat_conv
  end

  def bc_mva
    return unless mva?

    (def_valor_tot_ent * mva) / fat_conv
  end

  def invoice_icms_st
    return vICMSST.to_f if cod_oper_st_one? || cod_oper_st_two?
    return vICMSSTRet.to_f if cod_oper_st_three?

    0
  end

  def invoice_icms_st?
    invoice_icms_st.positive? || alternative_tax?
  end

  def valor_icms_st_transp = (def_valor_unit_icms_sup_transp * def_qtd_saida)

  def regime = 1

  def stock = last_estoque.to_f + movemented_stock

  def movemented_stock
    entry? ? def_qtd_entrada : -def_qtd_saida
  end

  # TODO: TESTS
  def transport_calc(initial, buy, sale)
    return initial unless last_estoque
    return buy if entry? && def_cod_oper_st.positive?
    return sale if sale? || final? || cod_oper_st_zero?
  end

  def avarage_transp(param_a, param_b)
    return 0 unless def_qtd_estoque.positive?

    ((last_estoque.to_f * param_a) + (def_qtd_entrada * param_b)) / def_qtd_estoque
  end

  def sequence(last)
    return unless last

    self.last_estoque = last.def_qtd_estoque
    self.last_icms_prop = last.def_icms_prop_unit_estoque
    self.last_saldo_bc = last.def_saldo_bc_unit_icms_sup
    self.last_saldo_unit = last.def_saldo_icms_unit_sup
    self.sum_ressarc = last.sum_ressarc.to_f + last.def_apur_ressarc
    self.sum_compl = last.sum_compl.to_f + last.def_apur_compl
  end

  def comparative
    return 0 unless sale?
    return (def_valor_icms_sup_transp_cf - def_icms_efetivo) if def_cod_enq_saida == 1
    return def_valor_icms_st_transp_fgn if def_cod_enq_saida == 2
    return def_valor_icms_st_transp_isen if def_cod_enq_saida == 3
    return def_valor_icms_sup_transp_uf if def_cod_enq_saida == 4

    0
  end

  def alternative_tax?
    pmc? || aliquot?
  end

  def zero_stock? = def_qtd_estoque.zero?

  def vicmsst?
    vICMSST.to_f.positive? || alternative_tax?
  end

  def vicmsstret?
    vICMSSTRet.to_f.positive? || alternative_tax?
  end

  def table_pmc?
    pmc.to_f.positive?
  end

  def table_aliquot?
    aliquot.to_f.positive? && pmc.to_f.zero?
  end

  def with_icms_st?
    invoice_icms_st.positive? && aliquot.to_f.zero? && pmc.to_f.zero?
  end

  def self.distribuition(start_date, end_date)
    sql = <<-SQL
      SELECT
        MONTH(invoice_date) AS month,
        SUM(CASE WHEN type_move = 0 THEN 1 ELSE 0 END) AS buys,
        SUM(CASE WHEN type_move = 1 THEN 1 ELSE 0 END) AS sales
      FROM
        movements
      WHERE
        invoice_date BETWEEN ? AND ?
      GROUP BY
        MONTH(invoice_date)
      ORDER BY month
    SQL

    fill_distribuition(
      connection.select_all(
        sanitize_sql_array([sql, start_date, end_date])
      )
    )
  end

  def self.fill_distribuition(sumary)
    sumary.each do |data|
      movement = new
      movement.month = data['month']
      movement.buys = data['buys']
      movement.sales = data['sales']
    end
  end

  def pmc_alert
    return unless entry? && pmc.to_f.positive?

    (((pmc - def_valor_tot_ent) / def_valor_tot_ent) * 100)
  end

  def update_mva
    aliquot = Aliquot.find_aliquot(item.NCM)
    self.mva = aliquot.mva if aliquot
  end
  # def self.orphans

  # end
end
