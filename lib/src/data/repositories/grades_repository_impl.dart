import 'package:drift/drift.dart';
import '../../domain/entities/nota_avaliacao.dart';
import '../../domain/entities/sync_entity.dart';
import '../../domain/repositories/grades_repository.dart';
import '../local/drift/app_database.dart';
import '../local/drift/mappers/nota_avaliacao_mapper.dart';
import '../../core/services/audit_service.dart';
import '../sync/sync_service.dart';

class GradesRepositoryImpl implements GradesRepository {
  final AppDatabase _db;
  final AuditService _audit;
  final SyncService _sync;

  GradesRepositoryImpl(this._db, this._audit, this._sync);

  @override
  Stream<List<NotaAvaliacao>> watchNotas({
    required int trimestre,
    String? anoLectivo,
    String? disciplina,
  }) {
    final query = _db.select(_db.notasAvaliacao)
      ..where((t) {
        var expr = t.isDeleted.equals(false) & t.trimestre.equals(trimestre);
        if (anoLectivo != null && anoLectivo.isNotEmpty) {
          expr = expr & t.anoLectivo.equals(anoLectivo);
        }
        if (disciplina != null && disciplina.isNotEmpty) {
          expr = expr & t.disciplina.equals(disciplina);
        }
        return expr;
      })
      ..orderBy([(t) => OrderingTerm(expression: t.disciplina), (t) => OrderingTerm(expression: t.valor, mode: OrderingMode.desc)]);
    return query.watch().map((rows) => rows.map((r) => r.toEntity()).toList());
  }

  Future<NotaAvaliacao?> _getById(String id) async {
    final row = await (_db.select(_db.notasAvaliacao)..where((t) => t.id.equals(id))).getSingleOrNull();
    return row?.toEntity();
  }

  @override
  Future<void> save(NotaAvaliacao nota) async {
    final existing = await _getById(nota.id);
    nota.syncStatus = SyncStatus.pendingSync;
    nota.updatedAt = DateTime.now();

    final companion = existing != null
        ? nota.toCompanion().copyWith(localId: Value(existing.localId!))
        : nota.toCompanion();

    await _db.into(_db.notasAvaliacao).insertOnConflictUpdate(companion);
    _sync.syncLocalToCloud();

    await _audit.log(
      entidade: 'NotaAvaliacao',
      entidadeId: nota.id,
      acao: existing == null ? 'CREATE' : 'UPDATE',
      novo: {'aluno': nota.alunoId, 'disciplina': nota.disciplina, 'valor': nota.valor},
    );
  }

  @override
  Future<void> delete(String id) async {
    final existing = await _getById(id);
    if (existing == null) return;
    existing.isDeleted = true;
    existing.updatedAt = DateTime.now();
    existing.syncStatus = SyncStatus.pendingSync;
    await _db.into(_db.notasAvaliacao).insertOnConflictUpdate(
          existing.toCompanion().copyWith(localId: Value(existing.localId!)),
        );
    _sync.syncLocalToCloud();
    await _audit.log(entidade: 'NotaAvaliacao', entidadeId: id, acao: 'DELETE');
  }
}
