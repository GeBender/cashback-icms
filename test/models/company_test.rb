# frozen_string_literal: true

require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  fixtures :companies

  def setup
    @model = companies(:one)
  end

  test 'reg' do
    assert_equal '0000', @model.reg
  end

  test 'cod ver' do
    assert_equal '17', @model.cod_ver
  end

  test 'cod fin' do
    assert_equal '1', @model.cod_fin
  end

  test 'tp amb' do
    assert_equal '1', @model.tp_amb
  end

  test 'show' do
    assert_equal '0000|17|1|000000001|08821476000103|1|20230101|20231231|1|', @model.show('2023-01-01'.to_date, '2023-12-31'.to_date)
  end
end
