# frozen_string_literal: true

require 'test_helper'

class MovementRendererTest < ActiveSupport::TestCase
  fixtures :movements

  def setup
    @initial = movements(:zero)
    @initial.type_move = :initial

    @buy = movements(:one)
    @sale = @model = movements(:two)

    @final = movements(:three)
    @final.type_move = :final
  end

  test 'reg to all' do
    assert_equal '2000', @model.reg
  end

  test 'cod part to each kind of movement' do
    # assert_equal '45453214001042', @initial.cod_part
    # assert_equal '45453214001042', @buy.cod_part
    # assert_equal '45453214001042', @sale.cod_part
    # assert_nil @final.cod_part
  end

  test 'cod item to all' do
    # assert_equal '303328', @model.cod_item
  end

  test 'descr item to all' do
    # assert_equal 'MALE TRIMEBUTINA | 200MG 30CAP EUR-GENERICO', @model.descr_item
  end

  test 'data to all' do
    assert_equal '20230101', @model.data
  end

  test 'chave acesso to each kind of movement' do
    # assert_equal '35230344463156000184550070063199821761393084', @initial.chave_acesso
    # assert_equal '35230344463156000184550070063199821761393084', @buy.chave_acesso
    # assert_equal '35230344463156000184550070063199821761393083', @sale.chave_acesso
    # assert_nil @final.chave_acesso
  end

  test 'cupom fiscal is empty to all' do
    assert_equal '', @model.cupom_fiscal
  end

  test 'tipo oper to each kind of movement' do
    assert_equal 'EI', @initial.tipo_oper
    assert_equal 'EN', @buy.tipo_oper
    assert_equal 'SD', @sale.tipo_oper
    assert_equal 'EF', @final.tipo_oper
  end

  test 'cfop to each kind of movement' do
    assert_equal '5405', @initial.cfop
    assert_equal '5405', @buy.cfop
    assert_equal '5405', @sale.cfop
    assert_nil @final.cfop
  end

  test 'cst to each kind of movement' do
    assert_equal '60', @initial.cst
    assert_equal '60', @buy.cst
    assert_equal '60', @sale.cst
    assert_nil @final.cst
  end

  test 'cod oper st to each kind of movement' do
    # assert_equal '1', @initial.cod_oper_st
    assert_equal '2', @buy.cod_oper_st
    assert_nil @sale.cod_oper_st
    assert_nil @final.cod_oper_st
  end

  test 'cod ean to each kind' do
    # assert_equal '7891317009915', @initial.cod_ean
    # assert_equal '7891317009915', @buy.cod_ean
    # assert_equal '7891317009915', @sale.cod_ean
    # assert_nil @final.cod_ean
  end

  test 'show initial' do
    # assert_equal(
    #   '2000|45453214001042|303328|MALE TRIMEBUTINA  -  200MG 30CAP EUR-GENERICO|' \
    #   '20230101|35230344463156000184550070063199821761393084||EI|5405|60|1|' \
    #   '7891317009915|2|25.28|50.56|0.15|0.56|0.08|0.04|5.9|7.79|3.9|0.76|' \
    #   '1.5|7.48|3.74|1||||||||||||||||||2|0.04|3.9|7.48|3.74|||',
    #   @initial.show
    # )
  end

  test 'show buy' do
    # assert_equal(
    #   '2000|45453214001042|303328|MALE TRIMEBUTINA  -  200MG 30CAP EUR-GENERICO|' \
    #   '20230201|35230344463156000184550070063199821761393084||EN|5405|60|2|' \
    #   '7891317009915|4|12.89|51.56|0.15|0.56|0.08|0.02|5.9|7.79|1.95|0.76|' \
    #   '1.5|7.48|1.87|1||||||||||||||||||4|0.02|1.95|7.48|1.87|||',
    #   @buy.show
    # )
  end

  test 'show buy with no icms st' do
    # assert_equal(
    #   '2000|94373981191|3033|MALE T-GENERICO|20230301|' \
    #   '35230344463156000184550070063199821761393086||EN|5927|60|4|' \
    #   '789009915|1|5.78|5.78||5.78||||||||||||||||||||||||||||1|0|' \
    #   '0|0|0|||',
    #   movements(:buy_no_tax).show
    # )
  end

  test 'show sale' do
    # assert_equal(
    #   '2000|45453214001042|303328|MALE TRIMEBUTINA  -  200MG 30CAP EUR-GENERICO|' \
    #   '20230101|35230344463156000184550070063199821761393083||SD|5405|60||' \
    #   '7891317009915||||||||||||||||||4|2|5.78|11.56|3.82|44.16|0|0|0|0|0|0|0|0|0|0|0|0|0|0|||',
    #   @sale.show
    # )
  end

  test 'show final' do
    # assert_equal(
    #   '2000||303328|MALE TRIMEBUTINA  -  200MG 30CAP EUR-GENERICO|' \
    #   '20230101|||EF|||||||||||||||||||||||||||||||||||||0|0|0|0|0|||',
    #   @final.show
    # )
  end
end
