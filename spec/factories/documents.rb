# frozen_string_literal: true

FactoryBot.define do
  factory :document do
    association :user

    report { { key: 'value' } }

    created_at { Time.now }
    updated_at { Time.now }
  end
end
