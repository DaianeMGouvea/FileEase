# frozen_string_literal: true

# == Schema Information
#
# Table name: documents
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  file       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  report     :jsonb
#
class Document < ApplicationRecord
  belongs_to :user
  mount_uploader :file, DocumentUploader
  validates :file, presence: true
end
