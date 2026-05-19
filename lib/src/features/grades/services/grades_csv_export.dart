import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import '../../../domain/entities/nota_avaliacao.dart';

class GradesCsvExport {
  static String _cell(String value) {
    final v = value.replaceAll('\n', ' ').trim();
    if (v.contains(';') || v.contains('"')) {
      return '"${v.replaceAll('"', '""')}"';
    }
    return v;
  }

  static Future<bool> save({
    required List<NotaAvaliacao> notas,
    required Map<String, String> alunoNomes,
    required Map<String, String> alunoNumeros,
    required Map<String, String> turmaPorAluno,
    required int trimestre,
    required String anoLectivo,
  }) async {
    if (notas.isEmpty) return false;

    final buffer = StringBuffer()
      ..writeln('Nº Aluno;Nome;Turma;Disciplina;Trimestre;Ano lectivo;Nota;Observação');

    final sorted = [...notas]..sort((a, b) {
        final na = alunoNomes[a.alunoId] ?? '';
        final nb = alunoNomes[b.alunoId] ?? '';
        final c = na.compareTo(nb);
        if (c != 0) return c;
        return a.disciplina.compareTo(b.disciplina);
      });

    for (final n in sorted) {
      buffer.writeln([
        _cell(alunoNumeros[n.alunoId] ?? ''),
        _cell(alunoNomes[n.alunoId] ?? n.alunoId),
        _cell(turmaPorAluno[n.alunoId] ?? ''),
        _cell(n.disciplina),
        _cell(NotaAvaliacao.trimestreLabel(n.trimestre)),
        _cell(n.anoLectivo),
        n.valor.toStringAsFixed(1).replaceAll('.', ','),
        _cell(n.observacao ?? ''),
      ].join(';'));
    }

    final bytes = utf8.encode('\uFEFF${buffer.toString()}');
    final fileName = 'notas_${anoLectivo}_t$trimestre.csv';

    final path = await FilePicker.platform.saveFile(
      fileName: fileName,
      bytes: bytes,
      type: FileType.custom,
      allowedExtensions: const ['csv'],
    );

    if (kDebugMode && path != null) {
      debugPrint('CSV guardado: $path');
    }
    return path != null;
  }
}
