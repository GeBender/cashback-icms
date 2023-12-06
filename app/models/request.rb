# frozen_string_literal: true

# == Request
#
# Stock items collectcion (Block 2000)
#
class Request
  include ActiveModel::Model
  include Renderers::RequestRenderer

  attr_accessor :company_ie,
                :start_date,
                :end_date

  def initialize(params = {})
    super params

    self.start_date = params[:start_date] ? params[:start_date].to_date : (Date.today - 5.years)
    self.end_date = params[:end_date] ? params[:end_date].to_date + 1.day : Date.today + 1.day
  end

  def company
    @company ||= Company.find_by(ie: company_ie)
    @company
  end

  def participants(dt_ini, dt_fin)
    Participant.where('first >= ? OR last <= ?', dt_ini, dt_fin).order(xNome: :ASC)
  end

  def items
    @items ||= Item.joins(:movements)
                   .where(movements: { invoice_date: start_date..end_date })
                   .where('cEAN > 0')
                   .where('items.cancel = 0')
                   .where('movements.cancel = 0')
                   .where('cEAN IS NOT NULL')
                   .distinct
    @items
  end

  def item(item_id: nil, ean: nil)
    item = Item.where('id = ? || cEAN = ?', item_id, ean).first
    item&.set_dates(start_date, end_date)
    item
  end

  def filename
    "#{company_ie}_#{start_date.strftime('%Y-%m-%d')}_#{end_date.strftime('%Y-%m-%d')}.txt"
  end

  def valid_items
    items.count(&:_valid?)
  end

  def invalid_items
    items.count(&:_invalid?)
  end

  def no_icms
    items.sum(&:no_icms)
  end

  def no_entries
    items.count(&:no_entries?)
  end

  def no_sales
    items.count(&:no_sales?)
  end

  def no_nothing
    items.count(&:no_movements?)
  end

  def profit_warnings
    items.count(&:negative_profit_margin?)
  end

  def stock_warnings
    items.count(&:zero_stocks?)
  end

  def pmc_warnings
    items.count(&:negative_pmc_margin?)
  end

  def with_ressarc
    items.count(&:ressarc?)
  end

  def with_compl
    items.count(&:compl?)
  end

  def no_results
    items.count(&:result?)
  end

  def ressarc
    items.sum(&:ressarc)
  end

  def compl
    items.sum(&:compl)
  end

  def result
    items.sum(&:result)
  end

  def pmcs
    items.sum(&:with_pmc)
  end

  def table_aliquots
    items.sum(&:with_aliquot)
  end

  def invoice_aliquots
    items.sum(&:with_invoice_icms)
  end
end
