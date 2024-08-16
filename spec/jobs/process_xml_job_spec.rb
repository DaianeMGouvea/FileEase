# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProcessXmlJob, type: :job do
  user = FactoryBot.create(:user)
  document = Document.new(user:,
                          file: Rack::Test::UploadedFile.new(
                            'spec/fixtures/files/test_file.xml', 'text_file/xml'
                          ))
  let(:xml_file) { double('File') }
  let(:xml_data) { double('XmlData') }
  let(:processor) { double('XmlProcessor') }
  let(:report_data) { { some: 'data' } }

  before do
    Sidekiq::Testing.inline!

    allow(File).to receive(:open).and_return(xml_file)
    allow(XmlData).to receive(:new).and_return(xml_data)
    allow(XmlProcessor).to receive(:new).and_return(processor)
    allow(processor).to receive(:process).and_return(report_data)
  end

  context 'when the document has a file attached' do
    before do
      # Stubbing the file path
      allow(document.file).to receive(:path).and_return('some_path')

      # Mocking and stubbing
      allow(Document).to receive(:find).and_return(document)

      # Stub the existence check for any file path
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?).with('some_path').and_return(true)
    end

    it 'processes the XML and updates the document with the report data' do
      expect(document).to receive(:update).with(report: report_data)
      ProcessXmlJob.perform_async(document.id)
    end
  end

  context 'when the document has no file attached' do
    before do
      allow(document).to receive(:file).and_return(nil)
      allow(Document).to receive(:find).and_return(document)
    end

    it 'does not process the XML and outputs a message' do
      expect(document).not_to receive(:update)
      expect do
        ProcessXmlJob.perform_async(document.id)
      end.to output("No file attached to the document.\n").to_stdout
    end
  end
end
