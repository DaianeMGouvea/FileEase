# frozen_string_literal: true

class XmlProcessor
  def initialize(xml_data)
    @xml_data = xml_data
  end

  def process
    {
      n_nf: extract_n_nf,
      serie: extract_serie,
      dh_emi: extract_dh_emi,
      emit: extract_emitente,
      dest: extract_destinatario,
      products: extract_products,
      tot_products: calculate_total_products,
      tot_taxes: calculate_total_taxes
    }
  end

  private

  def extract_serie
    @xml_data.xml_doc.at_xpath('//ns:ide/ns:serie', @xml_data.namespace)&.text
  end

  def extract_n_nf
    @xml_data.xml_doc.at_xpath('//ns:ide/ns:nNF', @xml_data.namespace)&.text
  end

  def extract_dh_emi
    @xml_data.xml_doc.at_xpath('//ns:ide/ns:dhEmi', @xml_data.namespace)&.text
  end

  def extract_emitente
    emitente = @xml_data.xml_doc.at_xpath('//ns:emit', @xml_data.namespace)
    "#{emitente.at_xpath('ns:xNome',
                         @xml_data.namespace)&.text}, CNPJ: #{emitente.at_xpath('ns:CNPJ', @xml_data.namespace)&.text}"
  end

  def extract_destinatario
    destinatario = @xml_data.xml_doc.at_xpath('//ns:dest', @xml_data.namespace)
    "#{destinatario.at_xpath('ns:xNome',
                             @xml_data.namespace)&.text}, CNPJ: #{destinatario.at_xpath('ns:CNPJ',
                                                                                        @xml_data.namespace)&.text}"
  end

  def extract_products
    @xml_data.xml_doc.xpath('//ns:det', @xml_data.namespace).map do |det_node|
      {
        cProd: det_node.at_xpath('ns:prod/ns:cProd', @xml_data.namespace)&.text,
        xProd: det_node.at_xpath('ns:prod/ns:xProd', @xml_data.namespace)&.text,
        NCM: det_node.at_xpath('ns:prod/ns:NCM', @xml_data.namespace)&.text,
        CFOP: det_node.at_xpath('ns:prod/ns:CFOP', @xml_data.namespace)&.text,
        uCom: det_node.at_xpath('ns:prod/ns:uCom', @xml_data.namespace)&.text,
        qCom: det_node.at_xpath('ns:prod/ns:qCom', @xml_data.namespace)&.text,
        vUnCom: det_node.at_xpath('ns:prod/ns:vUnCom', @xml_data.namespace)&.text.to_f,
        vProd: det_node.at_xpath('ns:prod/ns:vProd', @xml_data.namespace)&.text.to_f,
        vICMS: det_node.at_xpath('ns:imposto/ns:ICMS/ns:ICMS00/ns:vICMS', @xml_data.namespace)&.text.to_f.round(2),
        vIPI: det_node.at_xpath('ns:imposto/ns:IPI/ns:IPITrib/ns:vIPI', @xml_data.namespace)&.text.to_f.round(2),
        vPIS: det_node.at_xpath('ns:imposto/ns:PIS/ns:PISAliq/ns:vPIS', @xml_data.namespace)&.text.to_f.round(2),
        vCOFINS: det_node.at_xpath('ns:imposto/ns:COFINS/ns:COFINSNT/ns:vCOFINS',
                                   @xml_data.namespace)&.text.to_f.round(2)
      }
    end
  end

  def calculate_total_products
    extract_products.sum { |det| det[:vProd] }
  end

  def calculate_total_taxes
    extract_products.sum do |det|
      (det[:vICMS] || 0) + (det[:vIPI] || 0) + (det[:vPIS] || 0) + (det[:vCOFINS] || 0)
    end
  end
end
