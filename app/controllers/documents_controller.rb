# frozen_string_literal: true

require 'axlsx'

class DocumentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_document, only: %i[show export_to_excel]

  def new
    @document = Document.new
    @documents_recent = current_user.documents.created_recently.order(created_at: :desc)
    @documents_all = current_user.documents.limit(10).order(created_at: :desc)
  end

  def create
    @document = current_user.documents.build(document_params)

    if @document.file.content_type == 'application/zip'
      process_zip(@document)
    else
      process_single_document(@document)
    end
  end

  def show
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

  def process_single_document(document)
    if document.save
      ProcessXmlJob.perform_async(document.id)
      respond_to do |format|
        format.html { redirect_to new_document_path, notice: 'XML file is being processed' }
        format.json { render json: { message: 'ZIP file is being processed' }, status: :ok }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render json: { error: document.errors.full_messages.to_sentence }, status: :unprocessable_entity }
      end
    end
  end

  def process_zip(document)
    if ZipFileProcessor.new(document, current_user).process
      respond_to do |format|
        format.html { redirect_to new_document_path, notice: 'ZIP file is being processed' }
        format.json { render json: { message: 'ZIP file is being processed' }, status: :ok }
      end
    else
      respond_to do |format|
        format.html { render :new, alert: 'Failed to process ZIP file' }
        format.json { render json: { error: 'Failed to process ZIP file' }, status: :unprocessable_entity }
      end
    end
  end

  def set_document
    @document = Document.find(params[:id])
  end

  def document_params
    params.require(:document).permit(:file, :tab)
  end
end
