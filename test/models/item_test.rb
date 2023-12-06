# frozen_string_literal: true

require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  fixtures :companies, :items

  def setup
    @model = items(:one)

    @start_date = '2023-02-01'.to_date
    @end_date = '2023-03-31'.to_date
    @model.set_dates(@start_date, @end_date)
  end

  test 'set dates unit method' do
    assert_equal @start_date, @model.start_date
    assert_equal @end_date, @model.end_date
  end

  test 'set dates when call stock with dates params' do
    @model.stock('2023-01-01'.to_date, '2023-01-31'.to_date)

    assert_equal '2023-01-01'.to_date, @model.start_date
    assert_equal '2023-01-31'.to_date, @model.end_date
  end

  test 'set defaut dates when call stock with NO dates params' do
    model = items(:two)
    assert_nil model.start_date
    assert_nil model.end_date

    model.set_dates(@start_date, @end_date)
    model.stock

    assert_equal @start_date, model.start_date
    assert_equal @end_date, model.end_date
  end

  test 'stock like an array of movements' do
    stock = @model.stock(@start_date, @end_date)
    assert_kind_of Array, stock
    # assert_equal 6, stock.size
    assert_kind_of Movement, stock.first
  end

  test 'initials is a collection of movements' do
    initials = @model.initials

    assert_kind_of Movement, initials.first
  end

  test 'initials must find initials before start date' do
    initials = @model.initials

    # assert_equal 1, initials.size
    assert_equal false, initials.first.initial?
  end

  test 'sequence is a collection of movements' do
    sequence = @model.sequence

    assert_equal 4, sequence.size
    assert_kind_of Movement, sequence.first
  end

  test 'sequence must set initial to buys before first sale' do
    sequence = @model.sequence

    assert_equal false, sequence.first.initial?
    assert_equal false, sequence.second.initial?
    assert_equal true, sequence.third.sale?
  end

  test 'load stock forcing oper' do
    stock = @model.load_stock(Movement.limit(2), 'EI')
    assert_equal 2, stock.size
    assert_equal false, stock.first.initial?
    assert_equal false, stock.second.initial?
  end

  test 'load stock keeping tipo oper' do
    stock = @model.load_stock(Movement.limit(3))

    assert_equal false, stock.first.buy?
    assert_equal true, stock.second.sale?
    assert_equal true, stock.third.sale?
  end

  test 'avarage buy' do
    # assert_equal 15.414285714285715, @model.avarage_buy
  end

  test 'buys' do
    assert_equal 4, @model.buys
  end

  test 'sales' do
    # assert_equal 2, @model.sales
  end

  test 'bought' do
    # assert_equal 7, @model.bought
  end

  test 'sold' do
    assert_equal 2, @model.sold
  end

  test 'avarage sale' do
    assert_equal 5.78, @model.avarage_sale
  end

  test 'profit margin' do
    # assert_equal(-62.50231696014828, @model.profit_margin)
  end

  test 'pmc margin' do
    # assert_equal(100, @model.pmc_margin)
  end
end
