require 'rails_helper'

RSpec.describe Document, type: :model do
  let(:user) { FactoryBot.create(:user) }

  it "is valid with a file" do
    document = Document.new(user: user, file: Rack::Test::UploadedFile.new('spec/fixtures/files/test.xml', 'text/xml'))
    expect(document).to be_valid
  end

  it "is not valid without a file" do
    document = Document.new(user: user)
    expect(document).not_to be_valid
  end
end
