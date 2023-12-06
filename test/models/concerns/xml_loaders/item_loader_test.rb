# frozen_string_literal: true

require 'test_helper'

# rubocop:disable Metrics/ClassLength
class ItemLoaderTest < ActiveSupport::TestCase
  fixtures :companies

  def setup
    @company = companies(:one)
    @xml1 = XmlFixtures::NFs.in_one
    @xml2 = XmlFixtures::NFs.dest_cpf
    @det = @xml1.css('det')
    @item1 = Item.load_from_xml(
      @company,
      @det.first,
      @xml1.at('ide').at('dhEmi').text
    )
  end

  test 'find by' do
    # item = Item.find_item(@company, @xml1)

    # assert_equal '7891317009915', item.cEAN
    # assert_equal 'UN', item.uTrib
    # assert_equal 'UN', item.uCom
    # assert_equal @company, item.company
  end

  test 'must find by ean when exists' do
    # item = Item.find_by_(@company, 'cEAN', @xml1)
    # assert_equal '7891317009915', item.cEAN
    # assert_equal 'UN', item.uTrib
    # assert_equal 'UN', item.uCom
    # assert_equal @company, item.company
  end

  test 'must not find by ean when dont exists' do
    # item = Item.find_by_(@company, 'cEAN', @xml2)
    # assert_nil item
  end

  test 'must find by cprod when exists' do
    # item = Item.find_by_(@company, 'cProd', @xml1)
    # assert_equal '303328', item.cProd
    # assert_equal 'UN', item.uTrib
    # assert_equal 'UN', item.uCom
    # assert_equal @company, item.company
  end

  test 'must not find by cprod when dont exists' do
    # item = Item.find_by_(@company, 'cProd', @xml2)
    # assert_nil item
  end

  test 'must find by xprod when exists' do
    # item = Item.find_by_(@company, 'xProd', @xml1)
    # assert_equal 'MALE TRIMEBUTINA | 200MG 30CAP EUR-GENERICO', item.xProd
    # assert_equal 'UN', item.uTrib
    # assert_equal 'UN', item.uCom
    # assert_equal @company, item.company
  end

  test 'must not find by xprod when dont exists' do
    # item = Item.find_by_(@company, 'xProd', @xml2)
    # assert_nil item
  end

  test 'must return item when cean match' do
    # item = Item.find_item(@company, @xml1.css('det').first)
    # assert_equal '7891317009915', item.cEAN
  end

  test 'must return item when cprod match' do
    # item = Item.find_item(@company, @det[1])
    # assert_equal '3033', item.cProd
  end

  test 'must return item when xprod match' do
    # item = Item.find_item(@company, @det[2])
    # assert_equal 'MALE T-GENERICO FIXTURE', item.xProd
  end

  test 'must return nil when xprod none' do
    item = Item.find_item(@company, @det[3])
    assert_nil item
  end

  test 'load xml must return saved object' do
    assert_equal true, @item1.persisted?
  end

  test 'test initialization' do
    # item = Item.initialize_item(
    #   @company,
    #   @xml1.css('det').first
    # )
    # assert_equal @company, item.company
    # assert_equal 'UN', item.uCom
    # assert_equal 'UN', item.uTrib
  end

  test 'populate data' do
    # item = Item.new
    # item.populate_xml_data @xml1

    # assert_equal '7891317009915', item.cEAN
    # assert_equal '303328', item.cProd
    # assert_equal 'MALE TRIMEBUTINA | 200MG 30CAP EUR-GENERICO', item.xProd
    # assert_equal '30049039', item.NCM
    # assert_equal '1300201', item.CEST
  end

  test 'scope dates' do
    # assert_equal '2023-03-31T22:59:59-03:00'.to_time, @item1.first
    # assert_equal (Time.now + 5.days).to_date, @item1.last
  end

  test 'not valid when has blocked cfop' do
    assert_equal false, Item.pre_validate(false, false, true)
  end

  test 'valid when has no blocked cfop and has pmc' do
    assert_equal true, Item.pre_validate(1, nil, nil)
  end

  test 'valid when has no blocked cfop and has aliquot' do
    assert_equal true, Item.pre_validate(nil, 1, nil)
  end

  test 'do not update if persisted' do
    # item = Item.first
    # item.xProd = 'test'
    # item.populate_xml_data @det.first

    # assert_equal 'test', item.xProd
  end
end
# rubocop:enable Metrics/ClassLength