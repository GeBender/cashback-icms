# frozen_string_literal: true

# == Participant
#
# All Participant logical things
#
class Participant < ApplicationRecord
  include FromNFXml
  include Register

  belongs_to :company

  def reg = '1000'
  def cod_part = make_cod_part(document)
  def nome = xNome
  def cnpj = cnpj?(document) ? document : ''
  def cpf = cpf?(document) ? document : ''
  def ie = self.IE
  def cod_mun = cMun.try(:empty?) ? '5002704' : cMun

  def state_taxpayer_issuer?
    self.IE[0..1] == '28'
  end

  def inside_issuer?
    !outside_issuer?
  end

  def outside_issuer?
    self.UF != 'MS'
  end

  def populate_xml_data(xml)
    self.IE = get_xml_value(xml, 'IE')
    self.xNome = get_xml_value(xml, 'xNome')
    self.CRT = get_xml_value(xml, 'CRT')
    self.indIEDest = get_xml_value(xml, 'indIEDest')
  end

  def populate_xml_ender_data(xml)
    self.cMun = get_xml_value(xml, 'cMun')
    self.xMun = get_xml_value(xml, 'xMun')
    self.UF = get_xml_value(xml, 'UF')
  end

  def populate_if_new(nokogiri_xml)
    return if persisted?

    populate_xml_data(nokogiri_xml)
    populate_xml_ender_data(Participant.get_participant_ender(nokogiri_xml))
  end

  def self.load_from_xml(company, nokogiri_xml, date)
    participant = Participant.find_or_initialize_by(
      company:,
      document: get_participant_document(nokogiri_xml)
    )
    participant.populate_if_new(nokogiri_xml)
    participant.update_dates date
    participant.save
    participant
  end

  def show
    render(
      [reg, cod_part, nome, cnpj, cpf, ie, cod_mun]
    )
  end
end
