import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../domain/entities/mensalidade.dart';
import '../../../domain/entities/aluno.dart';
import '../../../core/services/pdf_font_service.dart';
import '../../../domain/entities/configuracao.dart';

class ReceiptPdfGenerator {
  static Future<void> generateAndPrint({
    required Mensalidade mensalidade,
    required Aluno aluno,
    ConfiguracaoInstitucional? config,
  }) async {
    final doc = pw.Document(theme: await PdfFontService.theme());

    final currencyFmt = NumberFormat.currency(locale: 'pt_AO', symbol: 'KZ');
    final dateFmt = DateFormat('dd/MM/yyyy');
    final monthYearFmt = DateFormat('MMMM yyyy', 'pt_BR');

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5,
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          config?.nomeInstituicao ?? 'EDUCLASS - SISTEMA DE GESTÃO',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
                        ),
                        pw.Text(config?.morada ?? 'Endereço da Instituição', style: const pw.TextStyle(fontSize: 9)),
                        pw.Text('NIF: ${config?.nif ?? '000000000'}', style: const pw.TextStyle(fontSize: 9)),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('RECIBO', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
                        pw.Text('Nº ${config?.reciboPrefixo ?? 'REC-'}${mensalidade.id.substring(0, 8).toUpperCase()}', 
                          style: const pw.TextStyle(fontSize: 10)),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Divider(),
                pw.SizedBox(height: 20),

                // Content
                pw.Text('DADOS DO ALUNO', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                pw.SizedBox(height: 8),
                pw.Text('Nome: ${aluno.nomeCompleto}', style: const pw.TextStyle(fontSize: 12)),
                pw.Text('ID: ${aluno.numeroAluno}', style: const pw.TextStyle(fontSize: 10)),
                
                pw.SizedBox(height: 24),
                pw.Text('DESCRIÇÃO DO PAGAMENTO', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                pw.SizedBox(height: 8),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Pagamento de Propina - ${monthYearFmt.format(DateTime(mensalidade.anoReferencia, mensalidade.mesReferencia))}', 
                      style: const pw.TextStyle(fontSize: 11)),
                    pw.Text(currencyFmt.format(mensalidade.valor), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                  ],
                ),
                
                pw.SizedBox(height: 40),
                pw.Divider(),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('TOTAL PAGO', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                    pw.Text(currencyFmt.format(mensalidade.valor), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                  ],
                ),

                pw.Spacer(),
                // Footer
                pw.Center(
                  child: pw.Column(
                    children: [
                      pw.Text('Data de Emissão: ${dateFmt.format(DateTime.now())}', style: const pw.TextStyle(fontSize: 8)),
                      pw.SizedBox(height: 4),
                      pw.Text(config?.textoRodapeRelatorio ?? 'Obrigado por confiar na nossa instituição.', 
                        style: pw.TextStyle(fontStyle: pw.FontStyle.italic, fontSize: 8)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save());
  }
}
