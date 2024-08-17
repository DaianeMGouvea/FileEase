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

      respond_to do |format|
        format.html do
          redirect_to new_document_path(file_name: @document.file.filename.to_s,
                                        document_id: @document.id)
        end
        format.json { render json: { file_name: @document.file.filename.to_s, document_id: @document.id } }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.json do
          render json: { error: @document.errors.full_messages.to_sentence }, status: :unprocessable_entity
        end
      end
    end
  end

  def show
    @document = Document.find(params[:id])
    @report = @document.report

    if @report.present? && @report['products'].present?
      @filtered_products = @report['products']

      if params[:NCM].present?
        @filtered_products = @filtered_products.select do |product|
          product['NCM'] == params[:NCM]
        end
      end

      if params[:xProd].present?
        @filtered_products = @filtered_products.select do |product|
          product['xProd'].downcase.include?(params[:xProd].downcase)
        end
      end
    else
      @filtered_products = []
    end
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
