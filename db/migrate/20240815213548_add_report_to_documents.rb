# frozen_string_literal: true

class AddReportToDocuments < ActiveRecord::Migration[7.0]
  def change
    add_column :documents, :report, :jsonb
  end
end
