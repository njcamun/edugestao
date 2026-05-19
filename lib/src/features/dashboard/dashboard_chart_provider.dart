import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/database_provider.dart';

final dashboardChartProvider = FutureProvider<({List<double> receitas, List<double> despesas, List<String> labels})>((ref) async {
  final db = ref.watch(databaseProvider);
  final now = DateTime.now();
  final receitas = <double>[];
  final despesas = <double>[];
  final labels = <String>[];
  const meses = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];

  for (var i = 5; i >= 0; i--) {
    final date = DateTime(now.year, now.month - i, 1);
    final mes = date.month;
    final ano = date.year;
    labels.add(meses[mes - 1]);

    final mensalidades = await (db.select(db.mensalidades)
          ..where((t) =>
              t.isDeleted.equals(false) &
              t.mesReferencia.equals(mes) &
              t.anoReferencia.equals(ano) &
              t.estado.equals('pago')))
        .get();
    receitas.add(mensalidades.fold<double>(0, (a, m) => a + m.valor));

    final custos = await (db.select(db.custosMensais)
          ..where((t) =>
              t.isDeleted.equals(false) &
              t.mesReferencia.equals(mes) &
              t.anoReferencia.equals(ano) &
              t.estado.equals('pago')))
        .get();
    despesas.add(custos.fold<double>(0, (a, c) => a + c.valor));
  }

  return (receitas: receitas, despesas: despesas, labels: labels);
});
