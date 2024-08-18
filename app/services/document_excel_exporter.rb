# frozen_string_literal: true

require 'axlsx'

class DocumentExcelExporter
  def self.export(document)
    Axlsx::Package.new do |p|
      p.workbook.add_worksheet(name: 'Document Report') do |sheet|
        bold_style = p.workbook.styles.add_style(b: true)

        sheet.add_row ['Emitente', document.report['emit']], style: [bold_style, nil]
        sheet.merge_cells('B1:E1')
        sheet.column_widths nil, 15

        sheet.add_row ['Destinatário', document.report['dest']], style: [bold_style, nil]
        sheet.merge_cells('B2:E2')
        sheet.column_widths nil, 15

        sheet.add_row ['Número NF', document.report['n_nf']], style: [bold_style, nil]
        sheet.merge_cells('B3:E3')
        sheet.column_widths nil, 15

        sheet.add_row ['Série', document.report['serie']], style: [bold_style, nil]
        sheet.merge_cells('B4:E4')
        sheet.column_widths nil, 15

        sheet.add_row ['Data de Emissão', document.report['dh_emi']], style: [bold_style, nil]
        sheet.merge_cells('B5:E5')
        sheet.column_widths nil, 15

        sheet.add_row ['Total de Impostos', document.report['tot_taxes']], style: [bold_style, nil]
        sheet.merge_cells('B6:E6')
        sheet.column_widths nil, 15

        sheet.add_row ['Total de Produtos', document.report['tot_products']], style: [bold_style, nil]
        sheet.merge_cells('B7:E7')
        sheet.column_widths nil, 15

        sheet.add_row []

        sheet.add_row ['NCM', 'Produto', 'Quantidade', 'Unidade', 'Preço Unitário', 'Preço Total', 'IPI', 'PIS', 'COFINS', 'ICMS'],
                      style: bold_style

        sheet.column_widths 20, 15, 15, 15, 15, 15, 15, 15, 15

        if document.report['products'].present?
          document.report['products'].each do |item|
            sheet.add_row [
              item['NCM'],
              item['xProd'],
              item['qCom'],
              item['uCom'],
              item['vUnCom'],
              item['vProd'],
              item['vIPI'],
              item['vPIS']
            ]
          end
        end
      end
    end
  end
end
