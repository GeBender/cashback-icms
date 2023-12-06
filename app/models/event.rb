# frozen_string_literal: true

# == Event
#
# All Event logics
#
class Event < ApplicationRecord
  include FromNFXml

  belongs_to :company

  def populate_xml_inf_data(xml)
    self.cOrgao = get_xml_value(xml, 'cOrgao')
    self.chNFe = get_xml_value(xml, 'chNFe')
    self.dhEvento = get_xml_value(xml, 'dhEvento')
    self.tpEvento = get_xml_value(xml, 'tpEvento')
    self.nSeqEvento = get_xml_value(xml, 'nSeqEvento')
  end

  def populate_xml_det_data(xml)
    self.descEvento = get_xml_value(xml, 'descEvento')
    self.nProt = get_xml_value(xml, 'nProt')
    self.xJust = get_xml_value(xml, 'xJust')
  end

  def self.load_from_xml(company, nokogiri_xml)
    event = find_or_initialize_by(
      company: company,
      event_id: nokogiri_xml.at('infEvento').get_attribute('Id')
    )
    event.populate_xml_inf_data(nokogiri_xml.at('infEvento'))
    event.populate_xml_det_data(nokogiri_xml.at('detEvento'))

    event.save
    event
  end
end
