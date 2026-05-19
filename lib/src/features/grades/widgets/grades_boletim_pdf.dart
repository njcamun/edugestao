import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../core/services/pdf_font_service.dart';
import '../../../domain/entities/aluno.dart';
import '../../../domain/entities/configuracao.dart';
import '../../../domain/entities/nota_avaliacao.dart';

class GradesBoletimPdf {
  static Future<void> generateAluno({
    required Aluno aluno,
    required List<NotaAvaliacao> notas,
    required int trimestre,
    required String anoLectivo,
    ConfiguracaoInstitucional? config,
    String? turmaNome,
  }) async {
    await _printDocument(
      pages: [
        (context) => _buildAlunoPage(
          aluno: aluno,
          notas: notas,
          trimestre: trimestre,
          anoLectivo: anoLectivo,
          config: config,
          turmaNome: turmaNome,
        ),
      ],
    );
  }

  static Future<void> generateTurma({
    required List<Aluno> alunos,
    required List<NotaAvaliacao> notas,
    required int trimestre,
    required String anoLectivo,
    ConfiguracaoInstitucional? config,
    Map<String, String>? turmaPorAluno,
  }) async {
    final byAluno = <String, List<NotaAvaliacao>>{};
    for (final n in notas) {
      byAluno.putIfAbsent(n.alunoId, () => []).add(n);
    }

    final pages = <pw.Widget Function(pw.Context)>[];
    for (final aluno in alunos) {
      final notasAluno = byAluno[aluno.id] ?? [];
      if (notasAluno.isEmpty) continue;
      pages.add(
        (_) => _buildAlunoPage(
          aluno: aluno,
          notas: notasAluno,
          trimestre: trimestre,
          anoLectivo: anoLectivo,
          config: config,
          turmaNome: turmaPorAluno?[aluno.id],
        ),
      );
    }

    if (pages.isEmpty) return;

    await _printDocument(pages: pages);
  }

  static Future<void> _printDocument({
    required List<pw.Widget Function(pw.Context)> pages,
  }) async {
    final doc = pw.Document(theme: await PdfFontService.theme());
    for (final buildPage in pages) {
      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) => buildPage(context),
        ),
      );
    }
    await Printing.layoutPdf(onLayout: (_) async => doc.save());
  }

  static pw.Widget _buildAlunoPage({
    required Aluno aluno,
    required List<NotaAvaliacao> notas,
    required int trimestre,
    required String anoLectivo,
    ConfiguracaoInstitucional? config,
    String? turmaNome,
  }) {
    final dateFmt = DateFormat('dd/MM/yyyy HH:mm');
    final sorted = [...notas]..sort((a, b) => a.disciplina.compareTo(b.disciplina));
    final media = sorted.isEmpty ? 0.0 : sorted.map((n) => n.valor).reduce((a, b) => a + b) / sorted.length;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        _header(config, 'BOLETIM DE NOTAS', '${NotaAvaliacao.trimestreLabel(trimestre)} · $anoLectivo'),
        pw.SizedBox(height: 16),
        pw.Text('Aluno: ${aluno.nomeCompleto.toUpperCase()}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
        pw.Text('Nº ${aluno.numeroAluno} · ${aluno.anoEscolaridade}', style: const pw.TextStyle(fontSize: 9)),
        if (turmaNome != null && turmaNome.isNotEmpty)
          pw.Text('Turma: $turmaNome', style: const pw.TextStyle(fontSize: 9)),
        pw.Text('Encarregado: ${aluno.nomeEncarregado}', style: const pw.TextStyle(fontSize: 9)),
        pw.SizedBox(height: 14),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.black),
              children: [
                _cell('DISCIPLINA', header: true),
                _cell('NOTA', header: true, center: true),
                _cell('OBS.', header: true),
              ],
            ),
            ...sorted.map(
              (n) => pw.TableRow(
                children: [
                  _cell(n.disciplina),
                  _cell(n.valor.toStringAsFixed(1), center: true),
                  _cell(n.observacao ?? '—', small: true),
                ],
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 12),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Text(
              'MÉDIA DO TRIMESTRE: ${media.toStringAsFixed(1)} valores',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
            ),
          ],
        ),
        pw.Spacer(),
        pw.Text('Emitido em ${dateFmt.format(DateTime.now())}', style: const pw.TextStyle(fontSize: 7)),
      ],
    );
  }

  static pw.Widget _header(ConfiguracaoInstitucional? config, String title, String subtitle) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              config?.nomeInstituicao.toUpperCase() ?? 'INSTITUIÇÃO DE ENSINO',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13),
            ),
            pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
            pw.Text(subtitle, style: const pw.TextStyle(fontSize: 8)),
          ],
        ),
        pw.Text('EDUCLASS', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8, color: PdfColor.fromInt(0xFF1E88E5))),
      ],
    );
  }

  static pw.Widget _cell(String text, {bool header = false, bool center = false, bool small = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        textAlign: center ? pw.TextAlign.center : pw.TextAlign.left,
        style: pw.TextStyle(
          fontSize: small ? 7 : (header ? 9 : 8),
          fontWeight: header ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: header ? PdfColors.white : PdfColors.black,
        ),
      ),
    );
  }
}
