# frozen_string_literal: true

class ProcessXmlJob
  include Sidekiq::Job

  def perform(document_id)
    document = Document.find(document_id)
    return Rails.logger.debug 'No file attached to the document.' if document.file.blank?

    xml_file = File.open(document.file.path)
    xml_data = XmlData.new(xml_file)
    processor = XmlProcessor.new(xml_data)
    report_data = processor.process

    document.update(report: report_data)
    Rails.logger.debug 'Document processed successfully!'
  end
end
