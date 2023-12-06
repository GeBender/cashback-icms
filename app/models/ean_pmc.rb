# frozen_string_literal: true

# == EanPmc
#
# All EAN PMC logical things
#
class EanPmc < ApplicationRecord
  def self.find_pmc(ean, date)
    pmc = where(ean:).where('start_date <= ?', date).order('start_date DESC').first
    pmc ? pmc.pmc : false
  end
end
