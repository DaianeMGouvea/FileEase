class Document < ApplicationRecord
  belongs_to :user
  mount_uploader :file, DocumentUploader
  validates :file, presence: true
end
