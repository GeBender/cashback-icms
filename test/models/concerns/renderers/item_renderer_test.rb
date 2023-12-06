# frozen_string_literal: true

require 'test_helper'

class ItemRendererTest < ActiveSupport::TestCase
  fixtures :items

  def setup
    @model = items :one
  end

  test 'reg' do
    assert_equal '4000', @model.reg
  end

  test 'cod item' do
    assert_equal '303328', @model.cod_item
  end

  test 'desc item' do
    assert_equal 'MALE TRIMEBUTINA | 200MG 30CAP EUR-GENERICO', @model.desc_item
  end

  test 'cod ean' do
    assert_equal '7891317009915', @model.cod_ean
  end

  test 'cod ant item' do
    assert_equal '', @model.cod_ant_item
  end

  test 'cod uni inv' do
    assert_equal 'UN', @model.uni_inv
  end

  test 'tipo item' do
    assert_equal '1', @model.tipo_item
  end

  test 'ncm' do
    assert_equal '30049039', @model.ncm
  end

  test 'cest' do
    assert_equal '1300201', @model.cest
  end

  test 'show' do
    assert_equal(
      '4000|303328|MALE TRIMEBUTINA  -  200MG 30CAP EUR-GENERICO|' \
      '7891317009915||UN|1|30049039|1300201|',
      @model.show
    )
  end
end
