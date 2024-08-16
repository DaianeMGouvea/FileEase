# frozen_string_literal: true

class ProcessXmlJob
  include Sidekiq::Job

  def perform(document_id)
    document = Document.find(document_id)
    return puts 'No file attached to the document.' unless document.file.present?

    xml_file = File.open(document.file.path)
    xml_data = XmlData.new(xml_file)
    processor = XmlProcessor.new(xml_data)
    report_data = processor.process

    document.update(report: report_data)
    puts 'Document processed successfully!'
  end
end
