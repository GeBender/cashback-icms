# frozen_string_literal: true

require 'test_helper'

class InvoiceTest < ActiveSupport::TestCase
  fixtures :companies, :invoices

  def setup
    @company = companies(:one)
    @xml = XmlFixtures::NFs.in_one
    @invoice = Invoice.load_from_xml @company, @xml
  end

  test 'load xml returns an invoice' do
    assert_kind_of Invoice, @invoice
  end

  test 'load xml must return saved object' do
    assert_equal true, @invoice.persisted?
  end

  test 'event cancel 110111' do
    assert_equal 0, @invoice.cancel

    @invoice.event_110111
    assert_equal 1, @invoice.cancel
  end

  test 'cancel event returs self model' do
    canceled = @invoice.event_110111
    assert_kind_of Invoice, canceled
  end

  test 'fpNF 1 and company equal dest is buy' do
    assert_equal true, invoices(:one).buy?
  end

  test 'fpNF 1 and company equal emit is sale' do
    assert_equal true, invoices(:two).sale?
  end

  test 'fpNF 0 and company equal dest is sale' do
    assert_equal true, invoices(:four).sale?
  end

  test 'fpNF 0 and company equal emit is buy' do
    assert_equal true, invoices(:five).buy?
  end

  test 'participant_doc is emit_cnpj when company cnpj is equal dest_doc' do
    assert_equal '45453214001042', invoices(:one).participant_doc
  end

  test 'participant_doc is dest_doc when company cnpj is equal emit_cnpj' do
    assert_equal '45453214001042', invoices(:two).participant_doc
  end

  test 'inside and outside issuer' do
    assert_equal true, invoices(:one).inside_issuer?
    assert_equal false, invoices(:five).inside_issuer?

    assert_equal false, invoices(:one).outside_issuer?
    assert_equal true, invoices(:five).outside_issuer?
  end

  test 'state taxpayer issuer?' do
    invoice = invoices(:two)
    assert_equal true, invoice.state_taxpayer_issuer?

    invoice = invoices(:six)
    assert_equal false, invoice.state_taxpayer_issuer?
  end

  test 'find issuer' do
    assert_equal '45453214001042', invoices(:one).issuer.document
    assert_equal '94373981191', invoices(:five).issuer.document
  end

  test 'xml data' do
    assert_equal @company, @invoice.company
    assert_equal '50230301206820001764550030051077501931240784', @invoice.key
    assert_equal '4.00', @invoice.version
    assert_equal '01206820001764', @invoice.emit_cnpj
    assert_equal '08821476000103', @invoice.dest_document
    assert_equal '50', @invoice.cUF
    assert_equal '93124078', @invoice.cNF
    assert_equal 'Venda de merc adq ou rec terc op suj reg S T contr', @invoice.natOp
    assert_equal '55', @invoice.mod
    assert_equal '3', @invoice.serie
    assert_equal '5107750', @invoice.nNF
    assert_equal '2023-03-31T22:59:59-03:00'.to_time, @invoice.dhEmi
    assert_equal 1, @invoice.tpNF
    assert_equal 1, @invoice.idDest
    assert_equal '5002704', @invoice.cMunFG
  end
end
