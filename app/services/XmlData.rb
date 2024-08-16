# frozen_string_literal: true

class XmlData
  attr_reader :xml_doc, :namespace

  def initialize(file)
    @xml_doc = Nokogiri::XML(file)
    @namespace = { 'ns' => 'http://www.portalfiscal.inf.br/nfe' }
  end
end
