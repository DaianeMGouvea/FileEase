# app/services/zip_file_processor.rb
class ZipFileProcessor
  def initialize(document, user)
    @document = document
    @user = user
  end

  def process
    return false unless @document.file.present?

    begin
      Zip::File.open(@document.file.path) do |zip_file|
        zip_file.each do |entry|
          process_entry(entry) if entry.name.end_with?('.xml')
        end
      end
      true
    rescue Zip::Error => e
      Rails.logger.error("Zip processing error: #{e.message}")
      false
    rescue StandardError => e
      Rails.logger.error("Failed to process ZIP file: #{e.message}")
      false
    end
  end

  private

  def process_entry(entry)
    xml_content = entry.get_input_stream.read
    temp_file = create_temp_file(entry.name, xml_content)

    uploaded_file = ActionDispatch::Http::UploadedFile.new(
      filename: entry.name,
      type: 'text/xml',
      tempfile: temp_file
    )

    new_document = @user.documents.build(
      user_id: @user.id,
      file: uploaded_file
    )

    if new_document.save
      ProcessXmlJob.perform_async(new_document.id)
    else
      Rails.logger.error("Failed to save document: #{new_document.errors.full_messages.to_sentence}")
    end
  ensure
    temp_file.close
    temp_file.unlink
  end

  def create_temp_file(name, content)
    temp_file = Tempfile.new([name, '.xml'])
    temp_file.binmode
    temp_file.write(content)
    temp_file.rewind
    temp_file
  end
end
