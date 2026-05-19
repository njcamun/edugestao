import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../../../core/services/pdf_font_service.dart';
import '../../../domain/entities/aluno.dart';
import '../../../domain/entities/matricula.dart';
import '../../../domain/entities/turma.dart';
import '../../../domain/entities/mensalidade.dart';
import '../../../domain/entities/custo.dart';
import '../../../domain/entities/configuracao.dart';

class ReportPdfGenerator {
  static Future<void> generateStudentList({
    required List<Aluno> alunos,
    required List<Matricula> matriculas,
    required List<Turma> turmas,
    required String anoLectivo,
    ConfiguracaoInstitucional? config,
  }) async {
    final doc = pw.Document(theme: await PdfFontService.theme());
    final dateFmt = DateFormat('dd/MM/yyyy HH:mm');

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            _buildHeader(config, 'LISTA NOMINAL DE ALUNOS', 'ANO LECTIVO $anoLectivo'),
            pw.SizedBox(height: 20),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.black, width: 1),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.black),
                  children: [
                    _cell('Nº', isHeader: true),
                    _cell('ID', isHeader: true),
                    _cell('NOME COMPLETO', isHeader: true),
                    _cell('TURMA', isHeader: true),
                    _cell('SEXO', isHeader: true),
                  ],
                ),
                ...List.generate(alunos.length, (index) {
                  final aluno = alunos[index];
                  final matricula = matriculas.where((m) => m.alunoId == aluno.id && m.anoLectivo == anoLectivo).firstOrNull;
                  final turma = turmas.where((t) => t.id == matricula?.turmaId).firstOrNull;

                  return pw.TableRow(
                    children: [
                      _cell('${index + 1}'),
                      _cell(aluno.numeroAluno),
                      _cell(aluno.nomeCompleto.toUpperCase()),
                      _cell(turma?.nomeTurma.toUpperCase() ?? 'N/A'),
                      _cell(aluno.sexo.toUpperCase()),
                    ],
                  );
                }),
              ],
            ),
            _buildFooter(alunos.length, dateFmt.format(DateTime.now())),
          ];
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save());
  }

  static Future<void> generateFinanceMap({
    required List<Aluno> alunos,
    required List<Mensalidade> mensalidades,
    required String anoLectivo,
    ConfiguracaoInstitucional? config,
  }) async {
    final doc = pw.Document(theme: await PdfFontService.theme());

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) {
          return [
            _buildHeader(config, 'MAPA DE MENSALIDADES', 'ANO LECTIVO $anoLectivo'),
            pw.SizedBox(height: 20),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.black),
                  children: [
                    _cell('ALUNO', isHeader: true, small: true),
                    ...List.generate(10, (i) => _cell('MÊS ${i + 1}', isHeader: true, small: true)),
                  ],
                ),
                ...alunos.map((aluno) {
                  final mAluno = mensalidades.where((m) => m.alunoId == aluno.id).toList();
                  return pw.TableRow(
                    children: [
                      _cell(aluno.nomeCompleto.toUpperCase(), small: true),
                      ...List.generate(10, (i) {
                        final mes = mAluno.where((m) => m.mesReferencia == (i + 1)).firstOrNull;
                        String status = '-';
                        if (mes != null) {
                          status = mes.estado == 'pago' ? 'PAGO' : (mes.estado == 'atrasado' ? 'ATR' : 'PEN');
                        }
                        return _cell(status, small: true, centered: true);
                      }),
                    ],
                  );
                }),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text('LEGENDA: PAGO = LIQUIDADO | ATR = EM ATRASO | PEN = PENDENTE', style: const pw.TextStyle(fontSize: 7)),
          ];
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save());
  }

  static Future<void> generateFinanceReport({
    required List<Mensalidade> mensalidades,
    required List<CustoMensal> custos,
    required List<Aluno> alunos,
    required String periodicidade,
    required String anoLectivo,
    required String tipoCusto,
    required String estado,
    ConfiguracaoInstitucional? config,
  }) async {
    final doc = pw.Document(theme: await PdfFontService.theme());
    final currencyFmt = NumberFormat.currency(locale: 'pt_AO', symbol: 'KZ');
    final dateFmt = DateFormat('dd/MM/yyyy HH:mm');

    // Aplicar Filtros
    List<Mensalidade> filteredMensalidades = [];
    if (tipoCusto == 'TODOS') {
      filteredMensalidades = mensalidades.where((m) => !m.isDeleted).toList();
      if (estado == 'PAGOS') {
        filteredMensalidades = filteredMensalidades.where((m) => m.estado == 'pago').toList();
      } else if (estado == 'NÃO PAGOS') {
        filteredMensalidades = filteredMensalidades.where((m) => m.estado != 'pago').toList();
      }
    }

    List<CustoMensal> filteredCustos = custos.where((c) => !c.isDeleted).toList();
    if (tipoCusto != 'TODOS') {
      filteredCustos = filteredCustos.where((c) => c.tipo == tipoCusto).toList();
    }
    if (estado == 'PAGOS') {
      filteredCustos = filteredCustos.where((c) => c.estado == 'PAGO').toList();
    } else if (estado == 'NÃO PAGOS') {
      filteredCustos = filteredCustos.where((c) => c.estado == 'PENDENTE').toList();
    }

    double totalReceita = filteredMensalidades.fold(0, (sum, m) => sum + m.valor);
    double totalDespesa = filteredCustos.fold(0, (sum, c) => sum + c.valor);

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            _buildHeader(config, 'RELATÓRIO FINANCEIRO $periodicidade', 'FILTROS: TIPO: $tipoCusto | ESTADO: $estado'),
            pw.SizedBox(height: 20),
            
            if (filteredMensalidades.isNotEmpty) ...[
              _subHeader('RECEITAS (MENSALIDADES)'),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.black),
                    children: [_cell('ALUNO', isHeader: true), _cell('MÊS', isHeader: true), _cell('VALOR', isHeader: true)],
                  ),
                  ...filteredMensalidades.map((m) {
                    final aluno = alunos.where((a) => a.id == m.alunoId).firstOrNull;
                    return pw.TableRow(children: [
                      _cell(aluno?.nomeCompleto.toUpperCase() ?? 'N/A', small: true),
                      _cell('Mês ${m.mesReferencia}', centered: true),
                      _cell(currencyFmt.format(m.valor), centered: true),
                    ]);
                  }),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
                pw.Text('SUBTOTAL RECEITA: ${currencyFmt.format(totalReceita)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
              ]),
              pw.SizedBox(height: 20),
            ],

            if (filteredCustos.isNotEmpty) ...[
              _subHeader('DESPESAS (CUSTOS)'),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.black),
                    children: [_cell('DESCRIÇÃO', isHeader: true), _cell('TIPO', isHeader: true), _cell('VALOR', isHeader: true)],
                  ),
                  ...filteredCustos.map((c) => pw.TableRow(children: [
                    _cell(c.descricao.toUpperCase(), small: true),
                    _cell(c.tipo, centered: true),
                    _cell(currencyFmt.format(c.valor), centered: true),
                  ])),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
                pw.Text('SUBTOTAL DESPESA: ${currencyFmt.format(totalDespesa)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
              ]),
              pw.SizedBox(height: 20),
            ],

            pw.Divider(thickness: 2),
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
              pw.Text('BALANÇO FINAL:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
              pw.Text(currencyFmt.format(totalReceita - totalDespesa), 
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14, color: (totalReceita - totalDespesa >= 0) ? PdfColors.black : PdfColors.red)),
            ]),
            _buildFooter(filteredMensalidades.length + filteredCustos.length, dateFmt.format(DateTime.now())),
          ];
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save());
  }

  static pw.Widget _subHeader(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Text(text, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10, decoration: pw.TextDecoration.underline)),
    );
  }

  static Future<void> generateDebtReport({
    required List<Aluno> alunos,
    required List<Mensalidade> mensalidades,
    required String anoLectivo,
    ConfiguracaoInstitucional? config,
  }) async {
    final doc = pw.Document(theme: await PdfFontService.theme());
    final currencyFmt = NumberFormat.currency(locale: 'pt_AO', symbol: 'KZ');
    final dateFmt = DateFormat('dd/MM/yyyy HH:mm');

    final devedores = alunos.where((aluno) {
      return mensalidades.any((m) => m.alunoId == aluno.id && m.estado == 'atrasado');
    }).toList();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            _buildHeader(config, 'RELATÓRIO DE INADIMPLÊNCIA', 'DÍVIDAS ACTIVAS - ANO LECTIVO $anoLectivo'),
            pw.SizedBox(height: 20),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.black, width: 1),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.black),
                  children: [
                    _cell('Nº', isHeader: true),
                    _cell('ALUNO', isHeader: true),
                    _cell('MESES EM ATRAZO', isHeader: true),
                    _cell('TOTAL DÍVIDA', isHeader: true),
                  ],
                ),
                ...List.generate(devedores.length, (index) {
                  final aluno = devedores[index];
                  final mAtrazadas = mensalidades.where((m) => m.alunoId == aluno.id && m.estado == 'atrasado').toList();
                  final totalDivida = mAtrazadas.fold(0.0, (sum, m) => sum + m.valor);
                  final mesesText = mAtrazadas.map((m) => 'Mês ${m.mesReferencia}').join(', ');

                  return pw.TableRow(
                    children: [
                      _cell('${index + 1}'),
                      _cell(aluno.nomeCompleto.toUpperCase()),
                      _cell(mesesText, small: true),
                      _cell(currencyFmt.format(totalDivida)),
                    ],
                  );
                }),
              ],
            ),
            _buildFooter(devedores.length, dateFmt.format(DateTime.now())),
            pw.SizedBox(height: 20),
            pw.Text('NOTA: ESTE DOCUMENTO LISTA APENAS ALUNOS COM PAGAMENTOS EM ATRASO NO SISTEMA.',
                style: pw.TextStyle(fontSize: 8, fontStyle: pw.FontStyle.italic)),
          ];
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save());
  }

  static pw.Widget _buildHeader(ConfiguracaoInstitucional? config, String title, String subtitle) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(config?.nomeInstituicao.toUpperCase() ?? 'SISTEMA DE GESTÃO',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
            pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
            pw.Text(subtitle, style: const pw.TextStyle(fontSize: 9)),
          ],
        ),
        pw.Text('EDUCLASS', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8, color: PdfColor.fromInt(0xFF1E88E5))),
      ],
    );
  }

  static pw.Widget _buildFooter(int total, String date) {
    return pw.Column(
      children: [
        pw.SizedBox(height: 20),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('TOTAL DE REGISTOS: $total', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
            pw.Text('DATA DE EMISSÃO: $date', style: const pw.TextStyle(fontSize: 7)),
          ],
        ),
      ],
    );
  }

  static pw.Widget _cell(String text, {bool isHeader = false, bool small = false, bool centered = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        textAlign: centered ? pw.TextAlign.center : pw.TextAlign.left,
        style: pw.TextStyle(
          fontSize: small ? 7 : (isHeader ? 9 : 8),
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: isHeader ? PdfColors.white : PdfColors.black,
        ),
      ),
    );
  }
}
