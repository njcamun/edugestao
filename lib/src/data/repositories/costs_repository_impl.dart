import 'package:drift/drift.dart';
import '../../domain/entities/custo.dart';
import '../../domain/repositories/costs_repository.dart';
import '../local/drift/app_database.dart';
import '../local/drift/mappers/custo_mapper.dart';
import '../../core/services/audit_service.dart';
import '../../domain/entities/sync_entity.dart';
import '../sync/sync_service.dart';

class CostsRepositoryImpl implements CostsRepository {
  final AppDatabase _db;
  final AuditService _audit;
  final SyncService _sync;

  CostsRepositoryImpl(this._db, this._audit, this._sync);

  @override
  Stream<List<CustoMensal>> watchCustos() {
    return (_db.select(_db.custosMensais)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm(expression: t.data, mode: OrderingMode.desc)]))
        .watch()
        .map((rows) => rows.map((row) => row.toEntity()).toList());
  }

  @override
  Stream<List<CustoMensal>> watchCustosAdmin() {
    return (_db.select(_db.custosMensais)
          ..orderBy([(t) => OrderingTerm(expression: t.data, mode: OrderingMode.desc)]))
        .watch()
        .map((rows) => rows.map((row) => row.toEntity()).toList());
  }

  @override
  Future<void> saveCusto(CustoMensal custo) async {
    final existing = await getCustoById(custo.id);
    final isNew = existing == null;

    if (isNew) {
      custo.createdAt = DateTime.now();
    }
    custo.updatedAt = DateTime.now();
    custo.syncStatus = SyncStatus.pendingSync;

    final companion = existing != null
      ? custo.toCompanion().copyWith(localId: Value(existing.localId!))
      : custo.toCompanion();

    await _db.into(_db.custosMensais).insertOnConflictUpdate(companion);

    _sync.syncLocalToCloud();

    await _audit.log(
      entidade: 'Custo',
      entidadeId: custo.id,
      acao: isNew ? 'CREATE' : 'UPDATE',
      novo: {'descricao': custo.descricao, 'valor': custo.valor, 'estado': custo.estado},
    );
  }

  @override
  Future<void> deleteCusto(String id) async {
    final custo = await getCustoById(id);
    
    if (custo != null) {
      custo.isDeleted = true;
      custo.updatedAt = DateTime.now();
      custo.syncStatus = SyncStatus.pendingSync;
      
      await _db.into(_db.custosMensais).insertOnConflictUpdate(
        custo.toCompanion().copyWith(localId: Value(custo.localId!)),
      );

      _sync.syncLocalToCloud();
      await _audit.log(entidade: 'Custo', entidadeId: id, acao: 'SOFT_DELETE', anterior: {'descricao': custo.descricao});
    }
  }

  @override
  Future<void> permanentDeleteCusto(String id) async {
    await _sync.permanentDelete.hardDeleteCusto(id);

    await _audit.log(
      entidade: 'Custo',
      entidadeId: id,
      acao: 'HARD_DELETE',
      anterior: {'msg': 'Remoção definitiva do custo.'},
    );
  }

  @override
  Future<void> restoreCusto(String id) async {
    final custo = await getCustoById(id);
    if (custo != null) {
      custo.isDeleted = false;
      custo.updatedAt = DateTime.now();
      custo.syncStatus = SyncStatus.pendingSync;
      await _db.into(_db.custosMensais).insertOnConflictUpdate(
        custo.toCompanion().copyWith(localId: Value(custo.localId!)),
      );
      _sync.syncLocalToCloud();
    }
  }

  @override
  Future<CustoMensal?> getCustoById(String id) async {
    final query = _db.select(_db.custosMensais)..where((t) => t.id.equals(id));
    final rows = await query.get();
    return rows.isNotEmpty ? rows.first.toEntity() : null;
  }

  @override
  Future<void> checkAndGenerateMonthlyCosts() async {
    // Método desativado: Não gerar custos automáticos logo de início.
  }
}
