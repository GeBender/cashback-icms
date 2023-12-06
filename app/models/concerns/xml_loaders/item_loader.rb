# frozen_string_literal: true

# Loaders
# Loaders main module
#
module XmlLoaders
  # ItemLoader
  # Help to load the items lines
  #
  module ItemLoader
    include FromNFXml
    extend ActiveSupport::Concern

    class_methods do
      def find_item(company, ean)
        find_by(company:, cEAN: ean)
      end

      def load_from_xml(company, nokogiri_xml, date)
        ean = nokogiri_xml.at('cEAN').text.try(:empty?) ? nokogiri_xml.at('cEANTrib').text : nokogiri_xml.at('cEAN').text
        item = find_item(company, ean.to_i)
        return item if item

        new_item = new(company:)
        new_item.populate_xml_data(nokogiri_xml, ean.to_i)
        new_item.update_dates date
        new_item.save
        new_item
      end

      def pre_validate(pmc, aliquot, cfop_blocked)
        ((pmc || aliquot) && cfop_blocked.nil?)
      end
    end

    def populate_xml_data(nokogiri_xml, ean)
      ean.to_i.zero? ? populate_sem_gtin : populate_with_ean(nokogiri_xml, ean)
    end

    def populate_with_ean(nokogiri_xml, ean)
      update(
        cProd: nokogiri_xml.at('cProd').text,
        cEAN: ean,
        xProd: nokogiri_xml.at('xProd').text,
        NCM: nokogiri_xml.at('NCM').text,
        CEST: nokogiri_xml.at('CEST') ? nokogiri_xml.at('CEST').text : '',
        uCom: nokogiri_xml.at('uCom').text,
        uTrib: nokogiri_xml.at('uTrib').text
      )
    end

    def populate_sem_gtin
      update(
        cProd: 0,
        cEAN: 0,
        xProd: 'SEM GTIN',
        NCM: 0,
        CEST: 0,
        cancel: 1
      )
    end
  end
end
