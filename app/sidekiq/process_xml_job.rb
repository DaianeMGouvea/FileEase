require 'nokogiri'

class ProcessXmlJob
  include Sidekiq::Job

  def perform(document_id)
    document = Document.find(document_id)

    if document.file.present?
      xml_file = File.open(document.file.path)
      xml_doc = Nokogiri::XML(xml_file)

      # Registrar o namespace
      namespace = { 'ns' => 'http://www.portalfiscal.inf.br/nfe' }

      # Extração dos dados do documento fiscal
      serie = xml_doc.at_xpath('//ns:ide/ns:serie', namespace)&.text
      nNF = xml_doc.at_xpath('//ns:ide/ns:nNF', namespace)&.text
      dhEmi = xml_doc.at_xpath('//ns:ide/ns:dhEmi', namespace)&.text

      # Extração dos dados do emitente (somente CNPJ e nome)
      # Extração dos dados do emitente (somente CNPJ e nome)
      emitente = xml_doc.at_xpath('//ns:emit', namespace)
      emit_cnpj = emitente.at_xpath('ns:CNPJ', namespace)&.text
      emit_nome = emitente.at_xpath('ns:xNome', namespace)&.text

      # Extração dos dados do destinatário (somente CNPJ e nome)
      destinatario = xml_doc.at_xpath('//ns:dest', namespace)
      dest_cnpj = destinatario.at_xpath('ns:CNPJ', namespace)&.text
      dest_nome = destinatario.at_xpath('ns:xNome', namespace)&.text

      # Extração dos dados do destinatário (somente CNPJ e nome)
      destinatario_cnpj = xml_doc.at_xpath('//ns:dest/ns:CNPJ', namespace)&.text
      destinatario_nome = xml_doc.at_xpath('//ns:dest/ns:xNome', namespace)&.text

      # Extração dos dados dos produtos
      products = xml_doc.xpath('//ns:det/ns:prod', namespace).map do |product_node|
        {
          cProd: product_node.at_xpath('ns:cProd', namespace)&.text,
          xProd: product_node.at_xpath('ns:xProd', namespace)&.text,
          vProd: product_node.at_xpath('ns:vProd', namespace)&.text.to_f,
          vICMS: product_node.at_xpath('ancestor::ns:det/ns:imposto/ns:ICMS/ns:ICMS00/ns:vICMS', namespace)&.text.to_f,
          vIPI: product_node.at_xpath('ancestor::ns:det/ns:imposto/ns:IPI/ns:IPITrib/ns:vIPI', namespace)&.text.to_f,
          vPIS: product_node.at_xpath('ancestor::ns:det/ns:imposto/ns:PIS/ns:PISAliq/ns:vPIS', namespace)&.text.to_f,
          vCOFINS: product_node.at_xpath('ancestor::ns:det/ns:imposto/ns:COFINS/ns:COFINSAliq/ns:vCOFINS',
                                         namespace)&.text.to_f
        }
      end

      # Totalizadores
      total_produtos = products.sum { |product| product[:vProd] }
      total_impostos = products.sum do |product|
        product[:vICMS] + product[:vIPI] + product[:vPIS] + product[:vCOFINS]
      end

      # Gerar relatório
      report_data = {
        serie:,
        nNF:,
        dhEmi:,
        emit: "CNPJ: #{emit_cnpj}, Nome: #{emit_nome}",
        dest: "CNPJ: #{dest_cnpj}, Nome: #{dest_nome}",
        products:,
        total_produtos:,
        total_impostos:
      }

      document.update(report: report_data)

      puts 'Document processed successfully!'
    else
      puts 'No file attached to the document.'
    end
  end
end
