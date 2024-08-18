# frozen_string_literal: true

FactoryBot.define do
  factory :document do
    association :user

    file { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/test_file.xml'), 'application/xml') }
    report { { key: 'value' } }

    created_at { Time.zone.now }
    updated_at { Time.zone.now }
  end
end
