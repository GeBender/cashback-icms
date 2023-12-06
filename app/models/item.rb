# frozen_string_literal: true

# == Item
#
# All Items logical things
#
class Item < ApplicationRecord
  include XmlLoaders::ItemLoader
  include Renderers::ItemRenderer

  belongs_to :company
  has_many :movements

  attr_accessor :start_date, :end_date

  def set_margins_and_averages
    #  .where('profit_margin IS NULL')
    movements.where(type_move: 0)
             .each_with_index do |movement, index|
      movement.set_margins_and_averages
      movement.save
      puts ">>> Item: #{xProd} | " \
      "Buy: #{index} | "\
      "Price: #{movement.vUnTrib.round(2)} | "\
      "Average sale: #{movement&.average_sale&.round(2)} | " \
      "Profit margin: #{movement&.profit_margin&.round(2)} |" \
      "PMC: #{movement&.pmc&.round(2)} |" \
      "PMC Margin: #{movement&.pmc_alert&.round(2)}"
    end
  end

  def rescue_orphans
    rescue_by_x_prod
    rescue_by_c_prod
  end

  def rescue_by_x_prod
    Movement.where(xProd:).where(cEANTrib: 0).each do |movement|
      movement.rescue(id, cEAN)
    end
  end

  def rescue_by_c_prod
    orphans = Movement.where(cProd:)
                      .where(cEANTrib: 0)
                      .where('xProd LIKE ?', "#{xProd.split.first}%")
    orphans.each do |movement|
      movement.rescue(id, cEAN)
    end
  end

  def set_dates(start_date, end_date)
    self.start_date = start_date
    self.end_date = end_date
  end

  def stock(start_date = self.start_date, end_date = self.end_date)
    set_dates(start_date, end_date)
    @stock ||= initials + sequence + final
    load_stock @stock
  end

  def initials
    movements.where(type_move: 0)
             .where(invoice_date: (start_date - 2.months)..(start_date))
  end

  def sequence
    @sequence = movements.where(invoice_date: start_date..end_date)
    @sequence
  end

  def final
    @final ||= sequence.last.dup
    return [] unless @final

    @final.type_move = :final
    [@final]
  end

  def load_stock(collection, first_sale = nil, last = nil)
    @collection = collection.map do |movement|
      if movement.sale? && !first_sale
        first_sale = true
      elsif !first_sale
        movement.type_move = :initial
      end

      movement.sequence(last)
      set_things(movement)
      last = movement
    end
    @collection
  end

  def set_things(movement)
    @buys ||= @buys.to_i + 1 if movement.buy?
    @buys_with_pmc ||= @buys_with_pmc.to_i + 1 if movement.entry? && movement.pmc?
    @sum_pmc ||= @sum_pmc.to_f + (movement.pmc / movement.fat_conv) if movement.entry? && movement.pmc?

    @buys_with_aliquot ||= @buys_with_aliquot.to_i + 1 if movement.entry? && movement.aliquot?
    @sum_aliquot ||= @sum_aliquot.to_f + movement.aliquot if movement.entry? && movement.aliquot?

    @sale ||= @sale.to_i + 1 if movement.sale?
  end

  def avarage_pmc
    return if @buys_with_pmc.to_i.zero? || @sum_pmc.to_f.zero?

    @sum_pmc / @buys_with_pmc
  end

  def avarage_aliquot
    return unless @buys_with_aliquot.to_i.positive? && @sum_aliquot.to_f.positive?

    @sum_aliquot / @buys_with_aliquot
  end

  def normalize_pmcs
    # pmc = movements.where('pmc > ?', 0).limit(1)
  end

  def avarage_buy
    values = 0
    qtts = 0
    stock.each do |movement|
      next unless movement.entry?

      values += movement.def_valor_unit_ent
      qtts += 1
    end
    qtts.zero? ? 0 : (values / qtts)
  end

  def avarage_sale
    values = 0
    qtts = 0
    stock.each do |movement|
      next unless movement.sale?

      values += movement.def_valor_unit_saida
      qtts += 1
    end
    qtts.zero? ? 0 : (values / qtts)
  end

  def profit_margin
    (((avarage_sale - avarage_buy) / avarage_buy) * 100)
  end

  def pmc_margin
    return unless movements.any?

    movements.detect(&:pmc_alert)&.pmc_alert
  end

  def first_buy
    movements.where(type_move: :buy).first
  end

  def real_stock
    stock.reject(&:final?)
  end

  def buys
    real_stock.count(&:entry?)
  end

  def bought
    real_stock.sum(&:def_qtd_entrada)
  end

  def sold
    real_stock.sum(&:def_qtd_saida)
  end

  def sales
    real_stock.count(&:sale?)
  end

  def ressarc
    real_stock.sum(&:def_apur_ressarc)
  end

  def ressarc?
    ressarc.positive?
  end

  def compl
    real_stock.sum(&:def_apur_compl)
  end

  def compl?
    compl.positive?
  end

  def result?
    !compl? && !ressarc?
  end

  def result
    ressarc - compl
  end

  def no_entries?
    buys.zero?
  end

  def no_sales?
    sales.zero?
  end

  def no_movements?
    sales.zero? && buys.zero?
  end

  def negative_profit_margin?
    profit_margin.negative? && _valid?
  end

  def negative_pmc_margin?
    pmc_margin.to_f < -500
  end

  def zero_stock_rate
    zero_stocks = real_stock.count(&:zero_stock?)
    ((zero_stocks * 100) / real_stock.size)
  end

  def zero_stocks?
    zero_stock_rate > 5 && buys.positive? && sales.positive?
  end

  def _valid?
    buys.positive? && sales.positive? && (movements.count(&:pmc?).positive? || movements.count(&:aliquot?).positive?)
  end

  def _invalid?
    !_valid?
  end

  def canceled?
    cancel.positive?
  end

  def no_icms
    real_stock.reject(&:invoice_icms_st?).count
  end

  def with_pmc
    real_stock.count(&:table_pmc?)
  end

  def with_aliquot
    real_stock.count(&:table_aliquot?)
  end

  def with_invoice_icms
    real_stock.count(&:with_icms_st?)
  end

  def self.apply_batch(ean, batch)
    Item.find_by(cEAN: ean).movements.each do |movement|
      movement.batch = batch if movement.buy?
      movement.save
    end
  end

  def self.apply_pmc(ean, pmc)
    Item.find_by(cEAN: ean).movements.each do |movement|
      movement.pmc = pmc
      movement.save
    end
  end
end
