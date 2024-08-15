class ProcessXmlJob
  include Sidekiq::Job

  def perform(document_id)
    document = Document.find(document_id)
    if document.file.present?
      puts 'Document processed successfully!'
    else
      puts 'No file attached to the document.'
    end
  end
end
