# frozen_string_literal: true

require 'test_helper'

class MovementLoaderTest < ActiveSupport::TestCase
  fixtures :companies

  def setup
    @invoice = invoices :one
    @item = items :one
    @xml = XmlFixtures::NFs.in_one
    @det = @xml.css('det').first

    # @movement_xml = Movement.load_from_xml(
    #   @invoice,
    #   @item
    # )
  end

  # test 'load xml returns an movement' do
  #   assert_kind_of Movement, @movement_xml
  # end

  # test 'load xml must return saved object' do
  #   assert_equal true, @movement_xml.persisted?
  # end

  # test 'event cancel 110111' do
  #   assert_equal 0, @movement_xml.cancel

  #   @movement_xml.event_110111
  #   assert_equal 1, @movement_xml.cancel
  # end

  # test 'cancel event returs self model' do
  #   canceled = @movement_xml.event_110111
  #   assert_kind_of Movement, canceled
  # end

  # test 'type move' do
  #   assert_equal 'buy', @movement_xml.type_move
  # end

  # test 'prod data' do
  #   assert_equal '5405', @movement_xml.CFOP
  #   assert_equal 1, @movement_xml.qTrib
  #   assert_equal 65.95, @movement_xml.vUnTrib
  #   assert_equal 1.1, @movement_xml.vSeg
  #   assert_equal 35.26, @movement_xml.vDesc
  #   assert_equal 0.3, @movement_xml.vOutro
  # end

  # test 'ipi data' do
  #   assert_equal 1.23, @movement_xml.vIPI
  # end

  # test 'icms data' do
  #   assert_equal 60, @movement_xml.CST
  #   assert_equal 1.6, @movement_xml.pICMS
  #   assert_equal 2.49, @movement_xml.pICMSST
  #   assert_equal 10.35, @movement_xml.pST
  # end

  # test 'icms values' do
  #   assert_equal 1.19, @movement_xml.vICMS
  #   assert_equal 9.76, @movement_xml.vBC
  #   assert_equal 9.67, @movement_xml.vBCST
  #   assert_equal 0.19, @movement_xml.vICMSST
  #   assert_equal 9.19, @movement_xml.vFCPST
  # end

  # test 'populate icms ret' do
  #   assert_equal 59.76, @movement_xml.vBCSTRet
  #   assert_equal 6.19, @movement_xml.vICMSSTRet
  #   assert_equal 8.9, @movement_xml.vFCPSTRet
  # end
end
