import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../core/services/pdf_font_service.dart';
import '../../../domain/entities/aluno.dart';
import '../../../domain/entities/configuracao.dart';
import '../../../domain/entities/nota_avaliacao.dart';
import '../../../domain/entities/turma.dart';

/// Pauta da turma: alunos × disciplinas.
class GradesPautaPdf {
  static Future<void> generate({
    required Turma turma,
    required List<Aluno> alunos,
    required List<NotaAvaliacao> notas,
    required int trimestre,
    required String anoLectivo,
    ConfiguracaoInstitucional? config,
  }) async {
    if (alunos.isEmpty || notas.isEmpty) return;

    final disciplinas = notas.map((n) => n.disciplina).toSet().toList()..sort();
    final doc = pw.Document(theme: await PdfFontService.theme());

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (context) => [
          _header(
            config,
            'PAUTA DE NOTAS',
            '${turma.nomeTurma} · ${NotaAvaliacao.trimestreLabel(trimestre)} · $anoLectivo',
          ),
          pw.SizedBox(height: 12),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
            columnWidths: {
              0: const pw.FixedColumnWidth(120),
              for (var i = 0; i < disciplinas.length; i++) i + 1: const pw.FlexColumnWidth(),
            },
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.black),
                children: [
                  _cell('ALUNO', header: true),
                  ...disciplinas.map((d) => _cell(d, header: true, center: true)),
                  _cell('MÉD.', header: true, center: true),
                ],
              ),
              ...alunos.map((aluno) {
                final notasAluno = notas.where((n) => n.alunoId == aluno.id).toList();
                final valores = disciplinas.map((d) {
                  for (final n in notasAluno) {
                    if (n.disciplina == d) return n.valor;
                  }
                  return null;
                }).toList();
                final comValor = valores.whereType<double>().toList();
                final media = comValor.isEmpty ? null : comValor.reduce((a, b) => a + b) / comValor.length;

                return pw.TableRow(
                  children: [
                    _cell(aluno.nomeCompleto, small: true),
                    ...valores.map((v) => _cell(v != null ? v.toStringAsFixed(1) : '—', center: true)),
                    _cell(media != null ? media.toStringAsFixed(1) : '—', center: true),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (_) async => doc.save());
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
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
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
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        textAlign: center ? pw.TextAlign.center : pw.TextAlign.left,
        maxLines: 2,
        style: pw.TextStyle(
          fontSize: small ? 7 : (header ? 8 : 7),
          fontWeight: header ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: header ? PdfColors.white : PdfColors.black,
        ),
      ),
    );
  }
}
