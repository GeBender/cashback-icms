# frozen_string_literal: true

# == Company
#
# All Company things
#
class Company < ApplicationRecord
  include Register

  has_many :invoices
  has_many :participants
  has_many :items

  def reg = '0000'
  def cod_ver = '17'
  def cod_fin = '1'
  def reg_trib = '1'
  def tp_amb = '1'

  def show(dt_ini, dt_fin)
    render [
      reg, cod_ver, cod_fin, ie, cnpj, reg_trib, dt_ini.strftime('%Y%m%d'), dt_fin.strftime('%Y%m%d'), tp_amb
    ]
  end

  def finish
    items.each do |item|
      item.set_dates(Date.today - 5.years, Date.today)

      item.set_margins_and_averages
      item.cancel = true if item._invalid?
      puts "#{item.xProd} >>>>>>>>>> CANCELED <<<<<<<<<<" if item.cancel == 1

      item.save
    end
  end
end
