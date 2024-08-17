# frozen_string_literal: true

FactoryBot.define do
  factory :document do
    association :user

    report { { key: 'value' } }

    created_at { Time.zone.now }
    updated_at { Time.zone.now }
  end
end
