import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../domain/entities/aluno.dart';
import '../../domain/entities/mensalidade.dart';
import '../../domain/entities/configuracao.dart';

class ReportService {
  static Future<void> generateStudentsList({
    required List<Aluno> alunos,
    ConfiguracaoInstitucional? config,
    String? filtroTurno,
  }) async {
    final doc = pw.Document();
    final dateFmt = DateFormat('dd/MM/yyyy HH:mm');

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        header: (context) => _buildHeader(config, 'LISTAGEM DE ALUNOS'),
        footer: (context) => _buildFooter(context, dateFmt.format(DateTime.now())),
        build: (context) => [
          pw.SizedBox(height: 10),
          if (filtroTurno != null) pw.Text('Filtro: Turno $filtroTurno', style: const pw.TextStyle(fontSize: 10)),
          pw.SizedBox(height: 10),
          pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey900),
            cellAlignment: pw.Alignment.centerLeft,
            headers: ['Nº', 'Nome Completo', 'Ano', 'Encarregado', 'Contacto'],
            data: alunos.map((a) => [
              a.numeroAluno,
              a.nomeCompleto,
              a.anoEscolaridade,
              a.nomeEncarregado,
              a.telefonePrincipal,
            ]).toList(),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => doc.save());
  }

  static Future<void> generateFinancialReport({
    required List<Mensalidade> mensalidades,
    required double totalCustos,
    ConfiguracaoInstitucional? config,
    required String periodo,
  }) async {
    final doc = pw.Document();
    final currencyFmt = NumberFormat.currency(locale: 'pt_AO', symbol: 'KZ');

    final totalRecebido = mensalidades.where((m) => m.estado == 'pago').fold(0.0, (sum, m) => sum + m.valor);
    final totalPendente = mensalidades.where((m) => m.estado != 'pago').fold(0.0, (sum, m) => sum + m.valor);

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        header: (context) => _buildHeader(config, 'RELATÓRIO FINANCEIRO - $periodo'),
        build: (context) => [
          pw.SizedBox(height: 20),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard('TOTAL RECEBIDO', currencyFmt.format(totalRecebido), PdfColors.green900),
              _buildStatCard('TOTAL PENDENTE', currencyFmt.format(totalPendente), PdfColors.red900),
              _buildStatCard('TOTAL CUSTOS', currencyFmt.format(totalCustos), PdfColors.grey900),
            ],
          ),
          pw.SizedBox(height: 30),
          pw.Text('BALANÇO FINAL: ${currencyFmt.format(totalRecebido - totalCustos)}', 
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => doc.save());
  }

  static pw.Widget _buildHeader(ConfiguracaoInstitucional? config, String titulo) {
    return pw.Column(
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(config?.nomeInstituicao ?? 'EDUCLASS', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
            pw.Text(titulo, style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
          ],
        ),
        pw.Divider(thickness: 1),
      ],
    );
  }

  static pw.Widget _buildFooter(pw.Context context, String data) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 10),
      child: pw.Text('Emitido em: $data | Página ${context.pageNumber} de ${context.pagesCount}', 
        style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
    );
  }

  static pw.Widget _buildStatCard(String label, String value, PdfColor color) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(border: pw.Border.all(color: color), borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8))),
      child: pw.Column(
        children: [
          pw.Text(label, style: pw.TextStyle(fontSize: 8, color: color)),
          pw.Text(value, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
