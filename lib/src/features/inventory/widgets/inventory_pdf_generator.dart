import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../core/services/pdf_font_service.dart';
import '../../../domain/entities/ativo_inventario.dart';

class InventoryPdfGenerator {
  static Future<void> exportList({
    required List<AtivoInventario> ativos,
    String institutionName = 'EDUCLASS',
  }) async {
    final doc = pw.Document(theme: await PdfFontService.theme());
    final currency = NumberFormat.currency(locale: 'pt_AO', symbol: 'KZ');
    final dateFmt = DateFormat('dd/MM/yyyy HH:mm');

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (context) => [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    institutionName.toUpperCase(),
                    style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColor.fromInt(0xFF0D47A1)),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'INVENTÁRIO DE ACTIVOS',
                    style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
              pw.Text('EDUCLASS', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColor.fromInt(0xFF1E88E5))),
            ],
          ),
          pw.Text('Gerado em ${dateFmt.format(DateTime.now())}', style: const pw.TextStyle(fontSize: 9)),
          pw.SizedBox(height: 16),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey400),
            columnWidths: {
              0: const pw.FlexColumnWidth(1),
              1: const pw.FlexColumnWidth(2),
              2: const pw.FlexColumnWidth(1.2),
              3: const pw.FlexColumnWidth(1.5),
              4: const pw.FlexColumnWidth(1),
              5: const pw.FlexColumnWidth(1.2),
            },
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF1E88E5)),
                children: [
                  _h('Código'),
                  _h('Nome'),
                  _h('Categoria'),
                  _h('Local'),
                  _h('Estado'),
                  _h('Valor'),
                ],
              ),
              ...ativos.map(
                (a) => pw.TableRow(
                  children: [
                    _c(a.codigo),
                    _c(a.nome),
                    _c(a.categoria),
                    _c(a.localizacao),
                    _c(a.estado.name),
                    _c(currency.format(a.valorAquisicao)),
                  ],
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 12),
          pw.Text('Total: ${ativos.length} activo(s)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => doc.save());
  }

  static pw.Widget _h(String t) => pw.Padding(
        padding: const pw.EdgeInsets.all(6),
        child: pw.Text(t, style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 9)),
      );

  static pw.Widget _c(String t) => pw.Padding(
        padding: const pw.EdgeInsets.all(5),
        child: pw.Text(t, style: const pw.TextStyle(fontSize: 8)),
      );
}
