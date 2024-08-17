# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Documents', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:document) { FactoryBot.create(:document, user:) }

  before do
    sign_in user if defined?(sign_in)
  end

  describe 'GET /documents/new' do
    it 'renders the new document form' do
      get new_document_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include('form')
    end
  end

  describe 'POST /documents' do
    it 'renders the new document form with errors' do
      post documents_path, params: { document: { file: nil } }

      expect(response).to render_template(:new)
      expect(response.body).to include('form')
      expect(Document.count).to eq(0)
    end
  end
end
