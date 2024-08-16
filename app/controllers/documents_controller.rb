# frozen_string_literal: true

require 'axlsx'

class DocumentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_document, only: %i[show export_to_excel]

  def new
    @document = Document.new
  end

  def create
    @document = current_user.documents.build(document_params)
    if @document.save
      ProcessXmlJob.perform_async(@document.id)
      redirect_to @document, notice: 'Document was successfully uploaded.'
    else
      render :new
    end
  end

  def show
    @document = Document.find(params[:id])
  end

  def export_to_excel
    @document = Document.find(params[:id])
    excel_package = DocumentExcelExporter.export(@document)
    file_name = "document_#{@document.id}_report.xlsx"
    send_data excel_package.to_stream.read, filename: file_name,
                                            type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
  end

  private

  def set_document
    @document = Document.find(params[:id])
  end

  def document_params
    params.require(:document).permit(:file)
  end
end
