# frozen_string_literal: true

# == ImportJob
#
# Read a folder and import to database all XML files recursively
#
class ImportJob < ApplicationJob
  queue_as :default

  def perform(inscricao_estadual, directory)
    logger.info("Iniciando o job de IMPORTAÇÃO com argumentos: #{inscricao_estadual} e #{directory}")
    company = Company.find_by(ie: inscricao_estadual)

    traverse_directory(company, directory)
    apply_events(company)
    company.set_margins_and_avarages
    sumarize(company)

    logger.info('Job de IMPORTÇÃO concluído!')
  end

  # rubocop: disable Metrics/MethodLength
  def traverse_directory(company, directory)
    files_and_dirs = Dir.entries(directory)
    sorted_files_and_dirs = files_and_dirs.sort

    sorted_files_and_dirs.each_with_index do |file_name, index|
      next if file_name == '.'
      next if file_name == '..'

      file_path = File.join(directory, file_name)

      if File.directory?(file_path)
        traverse_directory(company, file_path)
      elsif File.file?(file_path) && File.extname(file_path) == '.xml'
        puts "#{index} >>> #{file_path}"
        process_xml_file(company, file_path)
      end
    end
  end
  # rubocop: enable Metrics/MethodLength

  def normalize(company)
    Movement.find_by(company:, cEANTrib: 0).each(&:normalize)
  end

  def process_xml_file(company, file_path)
    begin
      xml_file = File.open(file_path)
      nokogiri_xml = Nokogiri::XML(xml_file)

      document = process_document(company, nokogiri_xml)
      return unless document

      process_participants(company, nokogiri_xml)
      process_items(company, document, nokogiri_xml)
    rescue Nokogiri::XML::SyntaxError => e
      puts "Error parsing XML - #{file_path}: #{e}"
    end
  end

  def process_document(company, nokogiri_xml)
    process_event(company, nokogiri_xml) if nokogiri_xml.at('infEvento')
    process_invoice(company, nokogiri_xml) if nokogiri_xml.at('infNFe')
  end

  def process_event(company, nokogiri_xml)
    event = Event.load_from_xml(company, nokogiri_xml)
    # puts "EVENT: #{event.event_id}"
  end

  def process_invoice(company, nokogiri_xml)
    invoice = Invoice.load_from_xml(company, nokogiri_xml)
    # puts "INVOICE: #{invoice.key}"
    invoice
  end

  def process_participants(company, nokogiri_xml)
    process_emitter(company, nokogiri_xml.at('emit'), nokogiri_xml.at('ide').at('dhEmi').text, 'EMITTER')
    process_emitter(company, nokogiri_xml.at('dest'), nokogiri_xml.at('ide').at('dhEmi').text, 'DEST')
  end

  def process_emitter(company, participant, date, type)
    return false unless participant

    emitter = Participant.load_from_xml(company, participant, date)
    # puts "#{type}: #{emitter.document}"
  end

  def process_items(company, invoice, nokogiri_xml)
    nokogiri_xml.css('det').each do |invoice_item|
      date = nokogiri_xml.at('ide').at('dhEmi').text

      process_item(company, invoice, invoice_item, date)
    end
  end

  def process_item(company, invoice, invoice_item, date)
    cfop_blocked = Cfop.find_by(cfop: invoice_item.at('prod').at('CFOP').text)
    # return false unless Item.pre_validate(@pmc, @aliquot, cfop_blocked)
    return false unless cfop_blocked.nil?

    item = Item.load_from_xml(company, invoice_item, date)
    # puts "ITEM: #{item.xProd} (#{item.cEAN})"
    process_movement(invoice, invoice_item)
    item.rescue_orphans
  end

  def process_movement(invoice, invoice_item)
    Movement.load_from_xml(invoice, invoice_item)
    # puts "MOVEMENT #{invoice.key} / #{item.xProd}"
  end

  def apply_events(company)
    Event.where(company:).each do |event|
      invoice = Invoice.find_by(key: event.chNFe)
      if invoice
        invoice.send("event_#{event.tpEvento}")
        invoice.save
        Movement.where(invoice:).map { |movement| movement.send("event_#{event.tpEvento}").save }
      end
    end
  end

  def sumarize(company)
    puts ">>> #{Participant.where(company:).size} PARTICIPANTS"
    puts ">>> #{Item.where(company:).size} ITEMS"
    puts ">>> #{Invoice.where(company:).size} INVOICES"
    puts ">>> #{Movement.joins(:invoice).where('invoice.company_id': company.id).size} MOVEMENT"
  end
end
