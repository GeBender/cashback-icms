# frozen_string_literal: true

# == FromNFXml
# methods to work with NF documents
module FromNFXml
  extend ActiveSupport::Concern

  class_methods do
    def get_participant_document(dest)
      return false unless dest

      dest.at('CNPJ') ? dest.at('CNPJ').text : dest.at('CPF').text
    end

    def get_participant_ender(dest)
      return false unless dest

      dest.at('enderDest') || dest.at('enderEmit')
    end
  end

  def update_dates(date)
    self.first = date if first.nil? || first > date
    self.last = date if last.nil? || last < date
  end

  def get_xml_value(xml, field, none_default = '')
    return none_default unless xml

    xml.at(field) ? xml.at(field).text : none_default
  end
end
