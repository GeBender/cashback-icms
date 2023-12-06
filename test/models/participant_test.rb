# frozen_string_literal: true

require 'test_helper'

class ParticipantTest < ActiveSupport::TestCase
  fixtures :companies

  def setup
    @company = companies(:one)
    @xml = XmlFixtures::NFs.in_one
    @participant = Participant.load_from_xml @company, @xml.at('emit'), @xml.at('ide').at('dhEmi').text
  end

  test 'load xml returns a participant' do
    assert_kind_of Participant, @participant
  end

  test 'load xml must return saved object' do
    assert_equal true, @participant.persisted?
  end

  test 'xml data' do
    assert_equal @company, @participant.company
    assert_equal '01206820001764', @participant.document

    assert_equal '283332719', @participant.IE
    assert_equal 'PANPHARMA DISTRIBUIDORA DE MEDICAMENTOS LTDA', @participant.xNome
    assert_equal '3', @participant.CRT
    assert_equal '', @participant.indIEDest
    assert_equal '5002704', @participant.cMun
    assert_equal 'Campo Grande', @participant.xMun
    assert_equal 'MS', @participant.UF
  end

  test 'do not update if persisted' do
    participant = Participant.first
    participant.xNome = 'test'
    participant.populate_if_new @xml.at('emit')

    assert_equal 'test', participant.xNome
  end

  test 'reg' do
    assert_equal '1000', @participant.reg
  end

  test 'cod part' do
    assert_equal '01780216026004', @participant.cod_part
  end

  test 'nome' do
    assert_equal 'PANPHARMA DISTRIBUIDORA DE MEDICAMENTOS LTDA', @participant.nome
  end

  test 'cnpj' do
    assert_equal '01206820001764', @participant.cnpj
  end

  test 'cpf' do
    @participant.document = '94373981191'
    assert_equal '94373981191', @participant.cpf
  end

  test 'ie' do
    assert_equal '283332719', @participant.ie
  end

  test 'cod_mun' do
    assert_equal '5002704', @participant.cod_mun
  end

  test 'show' do
    assert_equal(
      '1000|01780216026004|' \
      'PANPHARMA DISTRIBUIDORA DE MEDICAMENTOS LTDA|' \
      '01206820001764||283332719|5002704|',
      @participant.show
    )
  end


end
