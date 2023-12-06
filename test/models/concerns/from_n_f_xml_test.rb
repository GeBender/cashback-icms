# frozen_string_literal: true

require 'test_helper'

class FromNFXMLTest < ActiveSupport::TestCase
  fixtures :participants
  def setup
    @participant = participants(:one)
  end

  test 'return false if dont have a dest' do
    assert_equal false, Invoice.get_participant_document(nil)
  end

  test 'retun cpf when has cpf' do
    xml = XmlFixtures::NFs.dest_cpf
    assert_equal '25719785191', Invoice.get_participant_document(xml.at('dest'))
  end

  test 'retun cnpj when has cpf' do
    xml = XmlFixtures::NFs.dest_cnpj
    assert_equal '08821476000103', Invoice.get_participant_document(xml.at('dest'))
  end

  test 'return false if dont have a ender' do
    assert_equal false, Invoice.get_participant_ender(nil)
  end

  test 'retun emit ender when is emitter' do
    xml = XmlFixtures::NFs.dest_cpf
    assert_equal '79042530', Invoice.get_participant_ender(xml.at('emit')).at('CEP').text
  end

  test 'retun dest ender when is dest' do
    xml = XmlFixtures::NFs.dest_cpf
    assert_equal 'MANY SCAFF', Invoice.get_participant_ender(xml.at('dest')).at('xLgr').text
  end

  test 'must update first when date is before value' do
    first = (Time.now - 10.days).to_date
    @participant.update_dates first
    assert_equal first, @participant.first
  end

  test 'must remain first when date is not before value' do
    first = (Time.now - 1.days).to_date
    @participant.update_dates first
    assert_equal (Time.now - 5.days).to_date, @participant.first
  end

  test 'must update last when date is after value' do
    last = (Time.now + 10.days).to_date
    @participant.update_dates last
    assert_equal last, @participant.last
  end

  test 'must remain last when date is not after value' do
    last = (Time.now + 1.days).to_date
    @participant.update_dates last
    assert_equal (Time.now + 5.days).to_date, @participant.last
  end

  test 'get existent value' do
    xml = XmlFixtures::NFs.in_one
    assert_equal '1', @participant.get_xml_value(xml.at('ide'), 'tpNF')
  end

  test 'get empty string on non existent value' do
    xml = XmlFixtures::NFs.in_one
    assert_equal '', @participant.get_xml_value(xml.at('ide'), 'CNFF')
  end

  test 'get informed defaut on non existent value' do
    xml = XmlFixtures::NFs.in_one
    assert_nil @participant.get_xml_value(xml.at('ide'), 'CNFF', nil)
  end

  test 'default if xml is nil' do
    assert_equal '', @participant.get_xml_value(nil, 'CNFF')
  end
end
