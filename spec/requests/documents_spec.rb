require 'rails_helper'

RSpec.describe "Documents", type: :request do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in user if defined?(sign_in)
  end

  describe "POST /documents" do
    it "creates a new document and redirects to its page" do
      post documents_path, params: { document: { file: fixture_file_upload('test.xml') } }
      expect(response).to redirect_to(document_path(Document.last))
    end
  end
end