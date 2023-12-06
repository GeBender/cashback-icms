# frozen_string_literal: true

require 'test_helper'

class RequestTest < ActiveSupport::TestCase
  fixtures :companies, :items

  def setup
    @dt_ini = '2023-01-01'.to_date
    @dt_fin = '2023-12-31'.to_date

    @request = Request.new(
      company_ie: '000000001',
      start_date: @dt_ini,
      end_date: @dt_fin
    )
  end

  test 'initializers' do
    assert_equal '000000001', @request.company_ie
    assert_equal @dt_ini, @request.start_date
    assert_equal @dt_fin + 1.day, @request.end_date
    assert_equal '2024-01-01'.to_date, @request.end_date
  end

  test 'initialized with no params' do
    request = Request.new

    assert_nil request.company_ie
    assert_equal((Date.today - 5.years), request.start_date)
    assert_equal Date.today + 1.day, request.end_date
  end

  test 'company' do
    assert_kind_of Company, @request.company

    request = Request.new
    assert_nil request.company
  end

  test 'participants is a collection of Participants' do
    participants = @request.participants(@dt_ini, @dt_fin)

    assert_kind_of ActiveRecord::Relation, participants
    assert_kind_of Participant, participants.first
  end

  test 'items is a collection of Items' do
    items = @request.items

    assert_kind_of ActiveRecord::Relation, items
    assert_kind_of Item, items.first
  end

  test 'item is an Item' do
    assert_kind_of Item, @request.item(item_id: 1)
    assert_kind_of Item, @request.item(ean: 789_009_915)
    assert_nil @request.item(item_id: 100)
  end

  test 'file name' do
    assert_equal '000000001_2023-01-01_2024-01-01.txt', @request.filename
  end
end
