# frozen_string_literal: true

module XmlFixtures
  class NFs
    FILE_PATH = 'test/fixtures/files/'

    def self.load_xml(filename)
      xml_content = File.open(FILE_PATH + filename)
      Nokogiri::XML(xml_content)
    end

    def self.in_one
      load_xml '50230301206820001764550030051077501931240784.xml'
    end

    def self.dest_cpf
      load_xml '50230308821476000103650010001165271011721614-nfce.xml'
    end

    def self.dest_cnpj
      in_one
    end

    def self.event_cancel
      load_xml '50230308821476000103650010001133011011396518-nfce-ordem evento-001.xml'
    end
  end
end
