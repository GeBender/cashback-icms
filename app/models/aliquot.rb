# frozen_string_literal: true

# == Aliquot
#
# All Aliquot logical things
#
class Aliquot < ApplicationRecord
  def self.find_aliquot(ncm)
    return false if ncm.try :empty?

    aliquot = where(ncm:).order('start_date DESC')
    aliquot.any? ? aliquot.first : find_aliquot(ncm.chop)
  end
end
