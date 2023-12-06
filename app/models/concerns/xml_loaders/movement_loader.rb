# frozen_string_literal: true

# Loaders
# Loaders main module
#
module XmlLoaders
  # MovementLoader
  # Help to load the Movement from XML Invoices
  #
  module MovementLoader
    include FromNFXml
    extend ActiveSupport::Concern

    class_methods do
      def load_from_xml(invoice, invoice_item)
        ean = invoice_item.at('cEANTrib').text.try(:empty?) ? invoice_item.at('cEAN').text : invoice_item.at('cEANTrib').text
        item = load_item(ean.to_i, invoice_item.at('xProd').text, invoice_item.at('cProd').text)
        ean = item.cEAN if ean.to_i.zero?

        movement = Movement.find_or_initialize_by(invoice:, item:)
        movement.populate_xml_data(invoice_item, ean)
        movement.invoice_date = invoice.dhEmi
        movement.type_move = invoice.buy? ? 0 : 1
        movement.invoice_key = invoice.key
        movement.tpNF = invoice.tpNF

        if invoice.issuer
          movement.ie_part = invoice.issuer.IE
          movement.uf_part = invoice.issuer.UF
          movement.doc_part = invoice.issuer.document
        end

        movement.correct_taxes(invoice_item.at('NCM').text)
        movement.save
        movement
      end

      def load_item(ean, x_prod, c_prod)
        ean_item = Item.find_by(cEAN: ean) if ean.positive?
        return ean_item if ean_item

        x_prod_item = Movement.where(xProd: x_prod)
                              .where('cEANTrib > ?', 0)
                              .first&.item
        return x_prod_item if x_prod_item

        c_prod_item = Movement.where(cProd: c_prod)
                              .where('xProd LIKE ?', "#{x_prod.split.first}%")
                              .where('cEANTrib > ?', 0).first&.item
        return c_prod_item if c_prod_item

        Item.find_by(cEAN: 0)
      end
    end

    def populate_xml_data(xml, ean)
      populate_prod_data xml.at('prod'), ean
      populate_ipi_data xml.at('imposto').css('IPI').first
      populate_icms_data xml.at('imposto').css('ICMS').first
    end

    def populate_prod_data(prod, ean)
      self.CFOP = prod.at('CFOP').text
      self.cProd = prod.at('cProd').text
      self.xProd = prod.at('xProd').text
      self.qTrib = prod.at('qTrib').text
      self.qCom = prod.at('qCom').text
      self.cEANTrib = ean
      self.uTrib = prod.at('uTrib').text
      self.uCom = prod.at('uCom').text
      self.vUnCom = prod.at('vUnCom').text
      self.vProd = prod.at('vProd').text
      self.vUnTrib = prod.at('vUnTrib').text
      self.vSeg = get_xml_value(prod, 'vSeg')
      self.vDesc = get_xml_value(prod, 'vDesc')
      self.vOutro = get_xml_value(prod, 'vOutro')

      return unless prod.at('med')

      self.pmc = prod.at('med').at('vPMC').text&.to_f
    end

    def populate_ipi_data(ipi)
      self.vIPI = get_xml_value(ipi, 'vIPI')
    end

    def populate_icms_data(icms)
      self.CST = get_xml_value(icms, 'CST')
      self.pICMS = get_xml_value(icms, 'pICMS')
      self.pICMSST = get_xml_value(icms, 'pICMSST')
      self.pST = get_xml_value(icms, 'pST')

      populate_icms_values(icms)
      populate_icms_ret(icms)
    end

    def populate_icms_values(icms)
      self.vICMS = get_xml_value(icms, 'vICMS')
      self.vBC = get_xml_value(icms, 'vBC')
      self.vBCST = get_xml_value(icms, 'vBCST')
      self.vICMSST = get_xml_value(icms, 'vICMSST')
      self.vFCPST = get_xml_value(icms, 'vFCPST')
    end

    def populate_icms_ret(icms)
      self.vBCSTRet = get_xml_value(icms, 'vBCSTRet')
      self.vICMSSTRet = get_xml_value(icms, 'vICMSSTRet')
      self.vFCPSTRet = get_xml_value(icms, 'vFCPSTRet')
    end

    # rubocop:disable Naming/VariableNumber
    def event_110111
      self.cancel = 1
      self
    end
    # rubocop:enable Naming/VariableNumber

    def correct_taxes(ncm)
      new_pmc = EanPmc.find_pmc(cEANTrib, invoice_date)
      new_aliquot = Aliquot.find_aliquot(ncm)&.internal_aliquot

      self.pmc = new_pmc if new_pmc
      self.aliquot = new_aliquot if new_aliquot
    end
  end
end
