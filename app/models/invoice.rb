# frozen_string_literal: true

# == Invoice
#
# All Invoice logics
#
class Invoice < ApplicationRecord
  include FromNFXml

  belongs_to :company
  has_many :movements

  def populate_xml_data(xml)
    update(
      cUF: get_xml_value(xml, 'cUF'), cNF: get_xml_value(xml, 'cNF'),
      natOp: get_xml_value(xml, 'natOp'), mod: get_xml_value(xml, 'mod'),
      serie: get_xml_value(xml, 'serie'), nNF: get_xml_value(xml, 'nNF'),
      dhEmi: get_xml_value(xml, 'dhEmi'), tpNF: get_xml_value(xml, 'tpNF'),
      idDest: get_xml_value(xml, 'idDest'), cMunFG: get_xml_value(xml, 'cMunFG')
    )
  end

  def icms_st?
    tpNF.positive?
  end

  # rubocop:disable Naming/VariableNumber
  def event_110111
    self.cancel = 1
    self
  end
  # rubocop:enable Naming/VariableNumber

  def company_cnpj
    @company_cnpj ||= company.cnpj
    @company_cnpj
  end

  def sale?
    (tpNF == 1 && company_cnpj == emit_cnpj) || (tpNF.zero? && company_cnpj == dest_document)
  end

  def buy?
    !sale?
  end

  def participant_doc
    dest_document == company_cnpj ? emit_cnpj : dest_document
  end

  def inside_issuer?
    !outside_issuer?
  end

  def outside_issuer?
    return false unless issuer

    issuer.outside_issuer?
  end

  def state_taxpayer_issuer?
    return false unless issuer

    issuer.state_taxpayer_issuer?
  end

  def issuer
    return false unless participant_doc.to_i.positive?

    @issuer ||= Participant.find_by(document: participant_doc)
    @issuer
  end

  def self.load_from_xml(company, nokogiri_xml)
    invoice = find_or_initialize_by(
      company: company,
      key: nokogiri_xml.at('infNFe').get_attribute('Id').delete('NFe'),
      version: nokogiri_xml.at('infNFe').get_attribute('versao'),
      emit_cnpj: nokogiri_xml.at('emit').at('CNPJ').text
    )
    invoice.dest_document = get_participant_document(nokogiri_xml.at('dest'))
    invoice.populate_xml_data(nokogiri_xml.at('ide'))

    invoice.save
    invoice
  end
end
