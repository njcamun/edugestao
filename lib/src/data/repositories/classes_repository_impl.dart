import 'package:drift/drift.dart';
import '../../domain/entities/turma.dart';
import '../../domain/entities/sync_entity.dart';
import '../../domain/repositories/classes_repository.dart';
import '../local/drift/app_database.dart';
import '../local/drift/mappers/turma_mapper.dart';
import '../sync/sync_service.dart';

class ClassesRepositoryImpl implements ClassesRepository {
  final AppDatabase _db;
  final SyncService _sync;

  ClassesRepositoryImpl(this._db, this._sync);

  @override
  Stream<List<Turma>> watchTurmas() {
    final query = _db.select(_db.turmas)
      ..where((t) => t.isDeleted.equals(false))
      ..orderBy([(t) => OrderingTerm(expression: t.nomeTurma)]);
    
    return query.watch().map((rows) => rows.map((row) => row.toEntity()).toList());
  }

  @override
  Stream<List<Turma>> watchTurmasAdmin() {
    final query = _db.select(_db.turmas)
      ..orderBy([(t) => OrderingTerm(expression: t.nomeTurma)]);
    
    return query.watch().map((rows) => rows.map((row) => row.toEntity()).toList());
  }

  @override
  Future<void> saveTurma(Turma turma) async {
    final existing = await getTurmaById(turma.id);
    turma.syncStatus = SyncStatus.pendingSync;
    turma.updatedAt = DateTime.now();

    final companion = existing != null
      ? turma.toCompanion().copyWith(localId: Value(existing.localId!))
      : turma.toCompanion();

    await _db.into(_db.turmas).insertOnConflictUpdate(companion);

    _sync.syncLocalToCloud();
  }

  @override
  Future<void> deleteTurma(String id) async {
    // Trava de Segurança: Verificar se há matrículas activas nesta turma
    final matriculasQuery = _db.select(_db.matriculas)
      ..where((t) => t.turmaId.equals(id) & t.isDeleted.equals(false));
    
    final matriculas = await matriculasQuery.get();
    
    if (matriculas.isNotEmpty) {
      throw Exception('NÃO É POSSÍVEL REMOVER ESTA TURMA POIS EXISTEM ALUNOS MATRICULADOS NELA.');
    }

    final turma = await getTurmaById(id);
    if (turma != null) {
      // Soft Delete: Inativação
      final updateQuery = _db.update(_db.turmas)..where((t) => t.id.equals(id));
      await updateQuery.write(
        TurmasCompanion(
          isDeleted: const Value(true),
          updatedAt: Value(DateTime.now()),
          syncStatus: const Value(SyncStatus.pendingSync),
        ),
      );

      _sync.syncLocalToCloud();
    }
  }

  @override
  Future<void> permanentDeleteTurma(String id) async {
    // 1. Apagar todas as mensalidades associadas a esta turma
    final mensalidadesQuery = _db.select(_db.mensalidades)..where((t) => t.turmaId.equals(id));
    final mensalidades = await mensalidadesQuery.get();
    
    await _db.transaction(() async {
      for (final m in mensalidades) {
        // Apagar pagamentos da mensalidade
        final pagamentosQuery = _db.select(_db.pagamentos)..where((t) => t.mensalidadeId.equals(m.id));
        final pagamentos = await pagamentosQuery.get();
        for (final p in pagamentos) {
          await (_db.delete(_db.pagamentos)..where((t) => t.id.equals(p.id))).go();
          _sync.deleteFromCloud('pagamentos', p.id);
        }
        // Apagar mensalidade
        await (_db.delete(_db.mensalidades)..where((t) => t.id.equals(m.id))).go();
        _sync.deleteFromCloud('mensalidades', m.id);
      }

      // 2. Apagar todas as matrículas associadas a esta turma
      final matriculasQuery = _db.select(_db.matriculas)..where((t) => t.turmaId.equals(id));
      final matriculas = await matriculasQuery.get();
      for (final mat in matriculas) {
        await (_db.delete(_db.matriculas)..where((t) => t.id.equals(mat.id))).go();
        _sync.deleteFromCloud('matriculas', mat.id);
      }

      // 3. Apagar a turma
      await (_db.delete(_db.turmas)..where((t) => t.id.equals(id))).go();
      _sync.deleteFromCloud('turmas', id);
    });
  }

  @override
  Future<void> restoreTurma(String id) async {
    final turma = await getTurmaById(id);
    if (turma != null) {
      await (_db.update(_db.turmas)..where((t) => t.id.equals(id))).write(
        TurmasCompanion(
          isDeleted: const Value(false),
          updatedAt: Value(DateTime.now()),
          syncStatus: const Value(SyncStatus.pendingSync),
        ),
      );
      _sync.syncLocalToCloud();
    }
  }

  @override
  Future<Turma?> getTurmaById(String id) async {
    final query = _db.select(_db.turmas)..where((t) => t.id.equals(id));
    final rows = await query.get();
    return rows.isNotEmpty ? rows.first.toEntity() : null;
  }
}
