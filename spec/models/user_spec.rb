# frozen_string_literal: true
require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with valid attributes' do
    user = User.new(email: 'test@example.com', password: 'password123')
    expect(user).to be_valid
  end

  it 'is not valid without an email' do
    user = User.new(password: 'password123')
    expect(user).not_to be_valid
  end

  it 'is not valid without a password' do
    user = User.new(email: 'test@example.com')
    expect(user).not_to be_valid
  end
end
