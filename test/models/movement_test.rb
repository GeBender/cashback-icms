# frozen_string_literal: true

require 'test_helper'

class MovementTest < ActiveSupport::TestCase
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

  test 'default order must be invoice_date asc' do
    assert_equal 10, Movement.all.first.id
    assert_equal 2, Movement.all.second.id
    assert_equal 3, Movement.all.third.id
  end

  test 'type move enums' do
    assert_equal true, @initial.initial?
    assert_equal true, @buy.buy?
    assert_equal true, @sale.sale?
    assert_equal true, @final.final?
  end

  test 'Movement belongs to Invoice' do
    assert_kind_of Invoice, @model.invoice
  end

  test 'movement belongs to Item' do
    assert_kind_of Item, @model.item
  end

  test 'entry to each type' do
    assert_equal true, @initial.entry?
    assert_equal true, @buy.entry?
    assert_equal false, @sale.entry?
    assert_equal false, @final.entry?
  end

  test 'bc pmc without pmc' do
    assert_nil(@model.bc_pmc)
  end

  test 'bc pmc with pmc' do
    bc_pmc = movements(:pmc_and_batch)
    bc_pmc.batch = nil

    assert_equal(22.14, bc_pmc.bc_pmc)
  end

  test 'invoice icms st' do
    assert_equal 0, @zero.invoice_icms_st
    assert_equal 1.5, @one.invoice_icms_st
    assert_equal 1.5, @two.invoice_icms_st
    assert_equal 12.54, @three.invoice_icms_st
    assert_equal 0, @four.invoice_icms_st
  end

  test 'valor icms st transp' do
    @cod_enq_one = movements(:four)
    @cod_enq_one.type_move = 1
    @cod_enq_one.last_saldo_bc = 10
    @cod_enq_one.qTrib = 2
    @cod_enq_one.aliquot = 2

    assert_equal 40, @cod_enq_one.valor_icms_st_transp
  end

  test 'regime' do
    assert_equal 1, @model.regime
  end

  test 'movemented stock' do
    assert_equal 2, @initial.movemented_stock
    assert_equal 4, @buy.movemented_stock
    assert_equal(-2, @sale.movemented_stock)
    assert_equal(-1, @final.movemented_stock)
  end

  test 'stock' do
    @buy.last_estoque = 4
    assert_equal 8, @buy.stock

    @sale.last_estoque = 4
    assert_equal 2, @sale.stock

    @final.last_estoque = 4
    assert_equal 3, @final.stock
  end

  # test 'movemented stock' do
  #   assert_equal(2, @buy.movemented_stock)
  #   assert_equal(-2, @sale.movemented_stock)
  # end

  # test 'vICMSST is float' do
  #   assert_equal true, Movement.new.vICMSST.is_a?(Float)
  # end

  # test 'vICMSSTRet is float' do
  #   assert_equal true, Movement.new.vICMSSTRet.is_a?(Float)
  # end
end
