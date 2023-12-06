# frozen_string_literal: true

require 'test_helper'

class MovementDefinerTest < ActiveSupport::TestCase
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

    @cod_enq_one = movements(:four)
    @cod_enq_one.type_move = 1
    @cod_enq_one.invoice.dest_document = nil
  end

  test 'define tipo oper to each type' do
    assert_equal 'EI', @initial.def_tipo_oper
    assert_equal 'EN', @buy.def_tipo_oper
    assert_equal 'SD', @sale.def_tipo_oper
    assert_equal 'EF', @final.def_tipo_oper
  end

  test 'bought qtty is nil to non entries' do
    assert_equal 0, @sale.def_qtd_entrada
  end

  test 'bought qtty without bach' do
    assert_equal 2, @initial.def_qtd_entrada
  end

  test 'bought qtty with bach' do
    assert_equal 4, @buy.def_qtd_entrada
  end

  test 'bought unitary value is nil to non entries' do
    assert_nil @sale.def_valor_unit_ent
  end

  test 'bought unitary value without bach' do
    assert_equal 25.28, @initial.def_valor_unit_ent
  end

  test 'bought unitary value with bach' do
    assert_equal 12.89, @buy.def_valor_unit_ent
  end

  test 'bought unitary value with bach and discount' do
    @buy.vDesc = 3
    assert_equal 12.14, @buy.def_valor_unit_ent
  end

  test 'bought total value is nil to non entries' do
    assert_equal 0, @sale.def_valor_tot_ent
  end

  test 'bought total value without bach' do
    assert_equal 50.56, @initial.def_valor_tot_ent
  end

  test 'bought total value with bach' do
    assert_equal 51.56, @buy.def_valor_tot_ent
  end

  test 'define aliq op prop' do
    assert_equal 0.15, @initial.def_aliq_op_prop

    @initial.pICMS = 0
    @initial.pmc = 35
    assert_equal 0.17, @initial.def_aliq_op_prop

    @initial.pmc = 0
    @initial.aliquot = 10
    assert_equal 10, @initial.def_aliq_op_prop

    @initial.aliquot = 0
    assert_equal 0, @initial.def_aliq_op_prop
  end

  test 'define bc op prop' do
    assert_equal 0, @zero.def_bc_op_prop

    other_zero = movements(:five)
    other_zero.type_move = 0
    assert_equal 0, other_zero.def_bc_op_prop

    assert_equal 0.56, @initial.def_bc_op_prop
  end

  test 'define icms op prop' do
    assert_equal 0, @zero.def_icms_op_prop
    assert_equal 0.084, @one.def_icms_op_prop
    assert_equal 0.084, @two.def_icms_op_prop
    assert_equal 0.0, @four.def_icms_op_prop

    # TODO: Test case 3
  end

  test 'define icms unit prop' do
    assert_equal 0.042, @initial.def_icms_unit_op_prop
  end

  test 'define icms fecomp' do
    assert_equal 0, @zero.def_icms_fecomp
    assert_equal 5.9, @one.def_icms_fecomp
    assert_equal 5.9, @two.def_icms_fecomp

    @three.vFCPSTRet = 15.9
    assert_equal 15.9, @three.def_icms_fecomp

    assert_equal 0, @four.def_icms_fecomp
  end

  test 'define bc icms st' do
    assert_equal 22.14, movements(:pmc_and_batch).def_bc_icms_st
    assert_equal 0, @zero.def_bc_icms_st
    assert_equal 7.79, @one.def_bc_icms_st
    assert_equal 7.79, @two.def_bc_icms_st
    assert_equal 1.23, @three.def_bc_icms_st
    assert_equal 0, @four.def_bc_icms_st
  end

  test 'define bc unit icms st' do
    assert_equal 3.895, @one.def_bc_unit_icms_st
  end

  test 'define aliq icms st' do
    assert_equal 0, @zero.def_aliq_icms_st
    assert_equal 0.7591, @one.def_aliq_icms_st
    assert_equal 0.7591, @two.def_aliq_icms_st
    assert_equal 0.155, @three.def_aliq_icms_st

    pmc_and_batch = movements(:pmc_and_batch)
    assert_equal 0.17, pmc_and_batch.def_aliq_icms_st

    pmc_and_batch.pmc = nil
    assert_equal 0.15, pmc_and_batch.def_aliq_icms_st

    pmc_and_batch.aliquot = nil
    assert_equal 0, pmc_and_batch.def_aliq_icms_st
  end

  test 'define icms st' do
    assert_equal 3.7638000000000003, movements(:pmc_and_batch).def_icms_st
    assert_equal 1.5, @one.def_icms_st
  end

  test 'define valor icms sup' do
    assert_equal 0, @zero.def_valor_icms_sup
    assert_equal 7.484, @one.def_valor_icms_sup
    assert_equal 7.484, @two.def_valor_icms_sup
    assert_equal 0.19065, @three.def_valor_icms_sup
    assert_equal 0, @four.def_valor_icms_sup
  end

  test 'define valor uni icms sup' do
    assert_equal 3.742, @initial.def_valor_uni_icms_sup
  end

  test 'define origem inf' do
    assert_equal 0, @zero.def_origem_inf
    assert_equal 1, @one.def_origem_inf
    assert_equal 1, @two.def_origem_inf
    assert_equal 2, @three.def_origem_inf
    assert_equal 3, @four.def_origem_inf
  end

  test 'cod enq saida' do
    assert_equal 2, movements(:six).def_cod_enq_saida
    assert_equal 3, movements(:three).def_cod_enq_saida
    assert_equal 4, movements(:pmc_and_batch).def_cod_enq_saida
    # assert_equal 0, @sale.def_cod_enq_saida

    # assert_equal 1, @cod_enq_one.def_cod_enq_saida
  end

  test 'define qtd saida' do
    assert_equal 2, @sale.def_qtd_saida
  end

  test 'def valor saida' do
    assert_equal 11.56, @sale.def_valor_saida
  end

  test 'define aliq icms efetiva' do
    assert_equal 3.82, @sale.def_aliq_icms_efetiva

    @cod_enq_one.aliquot = 10
    assert_equal 10, @cod_enq_one.def_aliq_icms_efetiva

    @cod_enq_one.pmc = 10
    assert_equal 0.17, @cod_enq_one.def_aliq_icms_efetiva

    @cod_enq_one.pICMS = 10
    assert_equal 0.1, @cod_enq_one.def_aliq_icms_efetiva
  end

  test 'define icm efetivo' do
    @cod_enq_one.pmc = 10
    assert_equal 0.9826000000000001, @cod_enq_one.def_icms_efetivo
  end

  test 'define icms prop unit transp' do
    assert_equal 0, @initial.def_icms_prop_unit_transp
    assert_equal 0, @buy.def_icms_prop_unit_transp
    assert_equal 0, @final.def_icms_prop_unit_transp

    @cod_enq_one.last_icms_prop = 10
    assert_equal 10, @cod_enq_one.def_icms_prop_unit_transp
  end

  test 'define icms prop transp' do
    @cod_enq_one.last_icms_prop = 10
    @cod_enq_one.qTrib = 2
    assert_equal 20, @cod_enq_one.def_icms_prop_transp
  end

  test 'define bc unit icms sup transp' do
    assert_equal 0, @initial.def_icms_prop_unit_transp
    assert_equal 0, @buy.def_icms_prop_unit_transp
    assert_equal 0, @final.def_icms_prop_unit_transp

    @cod_enq_one.last_saldo_bc = 10
    assert_equal 10, @cod_enq_one.def_bc_unit_icms_sup_transp
  end

  test 'define bc icms sup transp' do
    @cod_enq_one.last_saldo_bc = 10
    @cod_enq_one.qTrib = 2
    assert_equal 20, @cod_enq_one.def_bc_icms_sup_transp
  end

  test 'define valor unit icms sup transp' do
    @cod_enq_one.last_saldo_bc = 10
    @cod_enq_one.qTrib = 2
    @cod_enq_one.aliquot = 0.2
    assert_equal 2, @cod_enq_one.def_valor_unit_icms_sup_transp
  end

  test 'define valor icms sup transp cf' do
    assert_equal 0, @sale.def_valor_icms_sup_transp_cf

    @cod_enq_one.last_saldo_bc = 10
    @cod_enq_one.qTrib = 2
    @cod_enq_one.aliquot = 0.2
    # assert_equal 4, @cod_enq_one.def_valor_icms_sup_transp_cf
  end

  test 'define valor icms st transp fgn' do
    assert_equal 0, @sale.def_valor_icms_st_transp_fgn
    cod_enq_two = movements(:six)

    cod_enq_two.last_saldo_bc = 10
    cod_enq_two.qTrib = 2
    cod_enq_two.aliquot = 0.2
    assert_equal 3, cod_enq_two.def_valor_icms_st_transp_fgn
  end

  test 'define valor icms st transp isen' do
    assert_equal 0, @sale.def_valor_icms_st_transp_fgn
    cod_enq_three = movements(:three)

    cod_enq_three.type_move = 1
    cod_enq_three.last_saldo_bc = 100
    cod_enq_three.qTrib = 2
    cod_enq_three.aliquot = 0.2
    assert_equal 40, cod_enq_three.def_valor_icms_st_transp_isen
  end

  test 'define valor icms st transp UF' do
    assert_equal 0, @sale.def_valor_icms_st_transp_fgn
    cod_enq_four = movements(:pmc_and_batch)

    cod_enq_four.type_move = 1
    cod_enq_four.last_saldo_bc = 100
    cod_enq_four.qTrib = 2
    cod_enq_four.aliquot = 0.2
    assert_equal 30, cod_enq_four.def_valor_icms_sup_transp_uf
  end

  test 'define qtd estoque' do
    @sale.last_estoque = -50
    assert_equal 0, @sale.def_qtd_estoque

    @sale.last_estoque = 10
    assert_equal 8, @sale.def_qtd_estoque
  end

  # test 'previous stock' do
  #   assert_equal 0, @block_buy.previous_stock # no previous
  #   assert_equal 2, @block_sale.previous_stock
  # end

  # test 'icms prop unit transp' do
  #   assert_equal 0, @block_buy.icms_prop_unit_transp
  #   assert_equal 4.325, @block_sale.icms_prop_unit_transp
  # end

  # test 'transp methods case zero' do
  #   movement = movements(:one)
  #   movement.qTrib = 1
  #   previous = Stock.new(movement: movement, tipo_oper: 'EI')
  #   block = Stock.new(movement: movements(:two), tipo_oper: 'SD')
  #   assert_equal 0, block.icms_prop_unit_estoque
  #   assert_equal 0, block.saldo_bc_unit_icms_sup
  # end

  # test 'transp methods case first line' do
  #   block = Stock.new(movement: movements(:one), tipo_oper: 'EI')
  #   assert_equal 4.325, block.icms_prop_unit_estoque
  #   assert_equal 3.895, block.saldo_bc_unit_icms_sup
  # end

  # test 'transp methods case sale' do
  #   previous = Stock.new(movement: movements(:one), tipo_oper: 'EI')
  #   block = Stock.new(movement: movements(:one), tipo_oper: 'SD')
  #   assert_equal 4.325, block.icms_prop_unit_estoque
  #   assert_equal 3.895, block.saldo_bc_unit_icms_sup
  # end

  # test 'transp methods case média ponderada' do
  #   previous1 = Stock.new(movement: movements(:one), tipo_oper: 'EI')
  #   previous2 = Stock.new(movement: movements(:five), tipo_oper: 'EI')
  #   block = Stock.new(movement: movements(:one), tipo_oper: 'SD')
  #   assert_equal 5.550000000000001, block.icms_prop_unit_estoque
  #   assert_equal 4.29, block.saldo_bc_unit_icms_sup
  # end

  # test 'transp methods case tpnf zero' do
  #   movement = movements(:one)
  #   movement.qTrib = 10
  #   previous = Stock.new(movement: movement, tipo_oper: 'EI')
  #   block = Stock.new(movement: movements(:four), tipo_oper: 'EI')
  #   assert_equal 0.865, block.icms_prop_unit_estoque
  #   assert_equal 0.779, block.saldo_bc_unit_icms_sup
  # end

  # test 'base de cálculo do icms suportado transportado' do
  #   assert_equal 0, @block_buy.bc_icms_sup_transp
  #   assert_equal 7.79, @block_sale.bc_icms_sup_transp
  # end

  # test 'other transps case nil' do
  #   block = Stock.new(movement: movements(:one), tipo_oper: 'EI')
  #   assert_equal 0, block.valor_icms_st_transp_fgn
  #   assert_equal 0, block.valor_icms_st_transp_isen
  #   assert_equal 0, block.valor_icms_sup_transp_uf
  # end

  # test 'valor icms st transp fgnr case true' do
  #   block_buy = Stock.new(movement: movements(:one), tipo_oper: 'EN')

  #   movement = movements(:two)
  #   movement.CFOP = '5927'
  #   block = Stock.new(movement: movement, tipo_oper: 'SD')
  #   assert_equal 18.695999999999998, block.valor_icms_st_transp_fgn
  # end

  # test 'valor icms st transp isen case true' do
  #   block_buy = Stock.new(movement: movements(:one), tipo_oper: 'EN')

  #   movement = movements(:two)
  #   movement.CST = '40'
  #   movement.qTrib = 1
  #   block = Stock.new(movement: movement, tipo_oper: 'SD')

  #   assert_equal 9.347999999999999, block.valor_icms_st_transp_isen
  # end

  # test 'valor icms st transp uf case true' do
  #   block_buy = Stock.new(movement: movements(:one), tipo_oper: 'EN')
  #   movement = movements(:six)
  #   movement.CFOP = '1234'
  #   block = Stock.new(movement: movement, tipo_oper: 'SD')
  #   assert_equal 9.7375, block.valor_icms_sup_transp_uf
  # end

  # test 'saldo icms suportado' do
  #   assert_equal 10.15, @block_buy.saldo_icms_sup
  #   movement = movements(:two)
  #   movement.qTrib = 1
  #   sale = Stock.new(movement: movement, tipo_oper: 'SD')
  #   assert_equal 9.347999999999999, sale.saldo_icms_sup
  # end

  # test 'comparative' do
  #   assert_equal 0, @block_sale.comparative

  #   block_one = Stock.new(movement: movements(:four), tipo_oper: 'SD')
  #   assert_equal 0, block_one.comparative

  #   block_two = Stock.new(movement: movements(:six), tipo_oper: 'SD')
  #   assert_equal 9.7375, block_two.comparative

  #   block_three = Stock.new(movement: movements(:three), tipo_oper: 'SD')
  #   assert_equal 0, block_three.comparative

  #   block_four = Stock.new(movement: movements(:five), tipo_oper: 'SD')
  #   assert_equal 0, block_four.comparative
  # end

  # test 'alternative' do
  #   block = Stock.new(movement: movements(:six), tipo_oper: 'SD')
  #   assert_equal 11.07, block.bc_pmc
  # end

  # test 'calc pmc' do
  #   block = Stock.new(movement: movements(:six), tipo_oper: 'SD')
  #   assert_equal 11.07, block.bc_pmc

  #   assert_nil @block_sale.bc_pmc
  # end
end
