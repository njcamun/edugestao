import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/database_provider.dart';

class FinanceMonthSummary {
  final double receitasPagas;
  final double receitasPendentes;
  final double despesasPagas;
  final double despesasPendentes;
  final Map<String, double> despesasPorCategoria;

  const FinanceMonthSummary({
    required this.receitasPagas,
    required this.receitasPendentes,
    required this.despesasPagas,
    required this.despesasPendentes,
    required this.despesasPorCategoria,
  });

  double get saldo => receitasPagas - despesasPagas;
  double get receitasTotal => receitasPagas + receitasPendentes;
  double get despesasTotal => despesasPagas + despesasPendentes;
}

final financeMonthFilterProvider = StateProvider<({int mes, int ano})>((ref) {
  final now = DateTime.now();
  return (mes: now.month, ano: now.year);
});

final financeMonthSummaryProvider = FutureProvider<FinanceMonthSummary>((ref) async {
  final db = ref.watch(databaseProvider);
  final filter = ref.watch(financeMonthFilterProvider);

  final mensalidades = await (db.select(db.mensalidades)
        ..where((t) =>
            t.isDeleted.equals(false) &
            t.mesReferencia.equals(filter.mes) &
            t.anoReferencia.equals(filter.ano)))
      .get();

  double receitasPagas = 0, receitasPendentes = 0;
  for (final m in mensalidades) {
    if (m.estado == 'pago') {
      receitasPagas += m.valor;
    } else {
      receitasPendentes += m.valor;
    }
  }

  final custos = await (db.select(db.custosMensais)
        ..where((t) =>
            t.isDeleted.equals(false) &
            t.mesReferencia.equals(filter.mes) &
            t.anoReferencia.equals(filter.ano)))
      .get();

  double despesasPagas = 0, despesasPendentes = 0;
  final porCategoria = <String, double>{};
  for (final c in custos) {
    if (c.estado == 'pago') {
      despesasPagas += c.valor;
    } else {
      despesasPendentes += c.valor;
    }
    porCategoria[c.categoria] = (porCategoria[c.categoria] ?? 0) + c.valor;
  }

  return FinanceMonthSummary(
    receitasPagas: receitasPagas,
    receitasPendentes: receitasPendentes,
    despesasPagas: despesasPagas,
    despesasPendentes: despesasPendentes,
    despesasPorCategoria: porCategoria,
  );
});
