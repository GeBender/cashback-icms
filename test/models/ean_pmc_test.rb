# frozen_string_literal: true

require 'test_helper'

class EanPmcTest < ActiveSupport::TestCase
  fixtures :ean_pmcs

  test 'return last ean pmc when find by ean' do
    # assert_equal 7.77, EanPmc.find_pmc('12345')
  end

  test 'return false when not found' do
    # assert_equal false, EanPmc.find_pmc('1234')
  end
end
