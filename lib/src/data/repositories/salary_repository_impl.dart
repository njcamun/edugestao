import 'package:drift/drift.dart';
import '../../domain/entities/salario.dart';
import '../../domain/entities/sync_entity.dart';
import '../../domain/repositories/salary_repository.dart';
import '../local/drift/app_database.dart';
import '../local/drift/mappers/salario_mapper.dart';
import '../../core/services/audit_service.dart';
import '../sync/sync_service.dart';

class SalaryRepositoryImpl implements SalaryRepository {
  final AppDatabase _db;
  final AuditService _audit;
  final SyncService _sync;

  SalaryRepositoryImpl(this._db, this._audit, this._sync);

  @override
  Stream<List<Salario>> watchSalarios({int? mes, int? ano}) {
    final query = _db.select(_db.salarios)
      ..where((t) {
        var expr = t.isDeleted.equals(false);
        if (mes != null) expr = expr & t.mesReferencia.equals(mes);
        if (ano != null) expr = expr & t.anoReferencia.equals(ano);
        return expr;
      })
      ..orderBy([
        (t) => OrderingTerm(expression: t.anoReferencia, mode: OrderingMode.desc),
        (t) => OrderingTerm(expression: t.mesReferencia, mode: OrderingMode.desc),
      ]);
    return query.watch().map((rows) => rows.map((r) => r.toEntity()).toList());
  }

  @override
  Future<Salario?> getById(String id) async {
    final row = await (_db.select(_db.salarios)..where((t) => t.id.equals(id))).getSingleOrNull();
    return row?.toEntity();
  }

  @override
  Future<void> save(Salario salario) async {
    final existing = await getById(salario.id);
    salario.valorLiquido = Salario.calcularLiquido(salario.valorBase, salario.descontos, salario.bonus);
    salario.syncStatus = SyncStatus.pendingSync;
    salario.updatedAt = DateTime.now();

    final companion = existing != null
        ? salario.toCompanion().copyWith(localId: Value(existing.localId!))
        : salario.toCompanion();

    await _db.into(_db.salarios).insertOnConflictUpdate(companion);
    _sync.syncLocalToCloud();

    await _audit.log(
      entidade: 'Salario',
      entidadeId: salario.id,
      acao: existing == null ? 'CREATE' : 'UPDATE',
      novo: {'funcionario': salario.funcionarioNome, 'liquido': salario.valorLiquido},
    );
  }

  @override
  Future<void> marcarComoPago(String id) async {
    final s = await getById(id);
    if (s == null) return;
    s.estado = SalarioEstado.pago;
    s.dataPagamento = DateTime.now();
    await save(s);
  }

  @override
  Future<void> delete(String id) async {
    final s = await getById(id);
    if (s == null) return;
    s.isDeleted = true;
    s.updatedAt = DateTime.now();
    s.syncStatus = SyncStatus.pendingSync;
    await _db.into(_db.salarios).insertOnConflictUpdate(
      s.toCompanion().copyWith(localId: Value(s.localId!)),
    );
    _sync.syncLocalToCloud();
  }
}
