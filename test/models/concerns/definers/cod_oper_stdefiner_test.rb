# frozen_string_literal: true

require 'test_helper'

class CodeOperStDefinerTest < ActiveSupport::TestCase
  fixtures :movements

  def setup
    @initial = movements(:zero)
    @initial.type_move = :initial

    @buy = movements(:one)
    @sale = @model = movements(:two)

    @final = movements(:three)
    @final.type_move = :final
    set_alternatives
  end

  def set_alternatives
    @zero = movements(:four)
    @one = @initial.dup
    @one.invoice.emit_cnpj = '94373981191'
    @two = @buy
    @three = movements(:five)
    @three.type_move = 0
    @four = movements(:buy_no_tax)
  end

  test 'check cod oper st zero' do
    model = movements(:four)

    assert_equal false, @sale.cod_oper_st_zero?
    assert_equal true, model.cod_oper_st_zero?
  end

  test 'check cod oper st is one' do
    @buy.uf_part = 'RS'
    assert_equal true, @buy.cod_oper_st_one?
  end

  test 'check cod oper st is two' do
    assert_equal true, @buy.cod_oper_st_two?
  end

  test 'check cod oper st is three' do
    model = movements(:five)
    assert_equal true, model.cod_oper_st_three?
  end

  test 'check cod oper st is four' do
    model = movements(:buy_no_tax)
    assert_equal true, model.cod_oper_st_four?
  end

  test 'define cod oper st NIL when is a buy' do
    assert_nil @sale.def_cod_oper_st
  end

  test 'define cod oper st is ZERO invoice has no icms st' do
    assert_equal 0, @zero.def_cod_oper_st
  end

  test 'define cod oper st is ONE when has vicmsst and is and outside issuer and non zero' do
    assert_equal 1, @one.def_cod_oper_st
  end

  test 'define cod oper st is TWO when has vicmsst and is and inside issuer and non zero nor one' do
    assert_equal 2, @two.def_cod_oper_st
  end

  test 'define cod oper st is THREE when has vicmsstret and is non zero nor one nor two' do
    assert_equal 3, @three.def_cod_oper_st
  end

  test 'define cod oper st is FOUR when is non zero nor one nor two nor three' do
    assert_equal 4, @four.def_cod_oper_st
  end

  test 'cod 1,2,4 method' do
    assert_equal false, @zero.cod_oper_st_1_2_4?
    assert_equal true, @one.cod_oper_st_1_2_4?
    assert_equal true, @two.cod_oper_st_1_2_4?
    assert_equal false, @three.cod_oper_st_1_2_4?
    assert_equal true, @four.cod_oper_st_1_2_4?
  end
end
