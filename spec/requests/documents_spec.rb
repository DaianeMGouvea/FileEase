# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Documents', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:document) { FactoryBot.create(:document, user:) }

  before do
    sign_in user if defined?(sign_in)
    create_list(:document, 3, user:, created_at: 1.day.ago)
  end

  describe 'GET #show' do
    let(:report_data) do
      {
        'products' => [
          { 'NCM' => '1234', 'xProd' => 'Product A', 'qCom' => '10', 'uCom' => 'unit', 'vUnCom' => '1.0',
            'vProd' => '10.0', 'vIPI' => '0.5', 'vPIS' => '0.2' },
          { 'NCM' => '5678', 'xProd' => 'Product B', 'qCom' => '5', 'uCom' => 'unit', 'vUnCom' => '2.0',
            'vProd' => '10.0', 'vIPI' => '1.0', 'vPIS' => '0.4' }
        ]
      }
    end

    before do
      document.update!(report: report_data) # Ensure report_data is set
    end

    it 'renders the new document form' do
      get new_document_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include('form')
    end

    it 'shows the document and filters products by NCM' do
      get document_path(document), params: { NCM: '1234' }

      expect(response).to have_http_status(:success)
      expect(assigns(:filtered_products)).to match_array([
                                                           { 'NCM' => '1234', 'xProd' => 'Product A', 'qCom' => '10', 'uCom' => 'unit', 'vUnCom' => '1.0',
                                                             'vProd' => '10.0', 'vIPI' => '0.5', 'vPIS' => '0.2' }
                                                         ])
    end

    it 'shows the document and filters products by xProd' do
      get document_path(document), params: { xProd: 'Product B' }

      expect(response).to have_http_status(:success)
      expect(assigns(:filtered_products)).to match_array([
                                                           { 'NCM' => '5678', 'xProd' => 'Product B', 'qCom' => '5', 'uCom' => 'unit', 'vUnCom' => '2.0',
                                                             'vProd' => '10.0', 'vIPI' => '1.0', 'vPIS' => '0.4' }
                                                         ])
    end

    it 'shows the document with no filters applied' do
      get document_path(document)

      expect(response).to have_http_status(:success)
      expect(assigns(:filtered_products)).to match_array([
                                                           { 'NCM' => '1234', 'xProd' => 'Product A', 'qCom' => '10', 'uCom' => 'unit', 'vUnCom' => '1.0',
                                                             'vProd' => '10.0', 'vIPI' => '0.5', 'vPIS' => '0.2' },
                                                           { 'NCM' => '5678', 'xProd' => 'Product B', 'qCom' => '5', 'uCom' => 'unit', 'vUnCom' => '2.0',
                                                             'vProd' => '10.0', 'vIPI' => '1.0', 'vPIS' => '0.4' }
                                                         ])
    end
  end

  describe 'POST /documents' do
    context 'with an XML file' do
      it 'creates a document and processes it' do
        expect do
          post documents_path, params: { document: { file: fixture_file_upload('test_file.xml', 'application/xml') } }
        end.to change { Document.count }.by(1)

        expect(response).to redirect_to(new_document_path)
        expect(flash[:notice]).to eq('XML file is being processed')
      end

      it 'renders the new document form with errors if XML processing fails' do
        allow_any_instance_of(Document).to receive(:save).and_return(false)

        post documents_path, params: { document: { file: fixture_file_upload('test_file.xml', 'application/xml') } }

        expect(response).to render_template(:new)
      end
    end

    context 'with a ZIP file' do
      it 'processes the ZIP file and redirects' do
        expect do
          post documents_path, params: { document: { file: fixture_file_upload('test_file.zip', 'application/zip') } }
        end.to change { Document.count }.by(2) # Adjust this based on your ZIP processing logic

        expect(response).to redirect_to(new_document_path)
        expect(flash[:notice]).to eq('ZIP file is being processed')
      end

      it 'renders the new document form with errors if ZIP processing fails' do
        allow_any_instance_of(ZipFileProcessor).to receive(:process).and_return(false)

        post documents_path, params: { document: { file: fixture_file_upload('test_file.zip', 'application/zip') } }

        expect(response).to render_template(:new)

        expect(response.body).to include('Não há documentos recentes para exibir. Faça um upload ou olhe no histórico') # Ajuste conforme sua view
      end
    end
  end

  describe 'GET #show' do
    it 'shows the document and filters products' do
      get document_path(document), params: { NCM: '1234', xProd: 'Product' }

      expect(response).to have_http_status(:success)
      expect(response.body).to include('Relatório')
    end

    it 'shows the document with no filters applied' do
      get document_path(document)

      expect(response).to have_http_status(:success)
      expect(response.body).to include('Relatório')
    end
  end

  describe 'GET #export_to_excel' do
    it 'exports the document to an Excel file' do
      get export_to_excel_document_path(document)

      expect(response).to have_http_status(:success)
      expect(response.header['Content-Type']).to include('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
      expect(response.header['Content-Disposition']).to include("attachment; filename=\"document_#{document.id}_report.xlsx\"")
    end
  end
end
