import 'package:drift/drift.dart';
import '../../domain/entities/ativo_inventario.dart';
import '../../domain/entities/sync_entity.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../local/drift/app_database.dart';
import '../local/drift/mappers/ativo_inventario_mapper.dart';
import '../../core/services/audit_service.dart';
import '../sync/sync_service.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final AppDatabase _db;
  final AuditService _audit;
  final SyncService _sync;

  InventoryRepositoryImpl(this._db, this._audit, this._sync);

  @override
  Stream<List<AtivoInventario>> watchAtivos() {
    return (_db.select(_db.ativosInventario)..where((t) => t.isDeleted.equals(false)))
        .watch()
        .map((rows) => rows.map((r) => r.toEntity()).toList());
  }

  @override
  Future<AtivoInventario?> getAtivoById(String id) async {
    final row =
        await (_db.select(_db.ativosInventario)..where((t) => t.id.equals(id))).getSingleOrNull();
    return row?.toEntity();
  }

  @override
  Future<void> saveAtivo(AtivoInventario ativo) async {
    final existing = await getAtivoById(ativo.id);
    ativo.syncStatus = SyncStatus.pendingSync;
    ativo.updatedAt = DateTime.now();

    final companion = existing != null
        ? ativo.toCompanion().copyWith(localId: Value(existing.localId!))
        : ativo.toCompanion();

    await _db.into(_db.ativosInventario).insertOnConflictUpdate(companion);
    _sync.syncLocalToCloud();

    await _audit.log(
      entidade: 'AtivoInventario',
      entidadeId: ativo.id,
      acao: existing == null ? 'CREATE' : 'UPDATE',
      novo: {'nome': ativo.nome, 'codigo': ativo.codigo},
    );
  }

  @override
  Future<void> deleteAtivo(String id) async {
    final a = await getAtivoById(id);
    if (a == null) return;
    a.isDeleted = true;
    a.updatedAt = DateTime.now();
    a.syncStatus = SyncStatus.pendingSync;
    await _db.into(_db.ativosInventario).insertOnConflictUpdate(
      a.toCompanion().copyWith(localId: Value(a.localId!)),
    );
    _sync.syncLocalToCloud();
  }

  @override
  Stream<List<ManutencaoAtivo>> watchManutencoes(String ativoId) {
    return (_db.select(_db.manutencoesAtivo)
          ..where((t) => t.ativoId.equals(ativoId))
          ..orderBy([(t) => OrderingTerm(expression: t.data, mode: OrderingMode.desc)]))
        .watch()
        .map((rows) => rows.map((r) => r.toEntity()).toList());
  }

  @override
  Future<void> registrarManutencao(ManutencaoAtivo manutencao) async {
    await _sync.pushManutencaoAtivo(
      id: manutencao.id,
      ativoId: manutencao.ativoId,
      data: manutencao.data,
      descricao: manutencao.descricao,
      custo: manutencao.custo,
      realizadoPor: manutencao.realizadoPor,
    );

    await _db.into(_db.manutencoesAtivo).insert(
          ManutencoesAtivoCompanion.insert(
            id: manutencao.id,
            ativoId: manutencao.ativoId,
            data: manutencao.data,
            descricao: manutencao.descricao,
            custo: manutencao.custo,
            realizadoPor: Value(manutencao.realizadoPor),
          ),
        );

    final ativo = await getAtivoById(manutencao.ativoId);
    if (ativo != null) {
      ativo.ultimaManutencao = manutencao.data;
      if (ativo.estado == AtivoEstado.avariado) {
        ativo.estado = AtivoEstado.bom;
      }
      await saveAtivo(ativo);
    }

    await _audit.log(
      entidade: 'ManutencaoAtivo',
      entidadeId: manutencao.id,
      acao: 'CREATE',
      novo: {'ativoId': manutencao.ativoId, 'descricao': manutencao.descricao},
    );
  }
}
