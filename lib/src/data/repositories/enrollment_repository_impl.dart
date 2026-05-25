import 'package:drift/drift.dart';
import '../../domain/entities/matricula.dart';
import '../../domain/entities/sync_entity.dart';
import '../../domain/repositories/enrollment_repository.dart';
import '../local/drift/app_database.dart';
import '../local/drift/mappers/matricula_mapper.dart';
import '../sync/sync_service.dart';

class EnrollmentRepositoryImpl implements EnrollmentRepository {
  final AppDatabase _db;
  final SyncService _sync;

  EnrollmentRepositoryImpl(this._db, this._sync);

  @override
  Stream<List<Matricula>> watchMatriculas() {
    return (_db.select(_db.matriculas)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm(expression: t.dataMatricula, mode: OrderingMode.desc)]))
        .watch()
        .map((rows) => rows.map((row) => row.toEntity()).toList());
  }

  @override
  Stream<List<Matricula>> watchMatriculasAdmin() {
    return (_db.select(_db.matriculas)
          ..orderBy([(t) => OrderingTerm(expression: t.dataMatricula, mode: OrderingMode.desc)]))
        .watch()
        .map((rows) => rows.map((row) => row.toEntity()).toList());
  }

  @override
  Future<void> saveMatricula(Matricula matricula) async {
    final existing = await getMatriculaById(matricula.id);
    matricula.syncStatus = SyncStatus.pendingSync;
    matricula.updatedAt = DateTime.now();

    final companion = existing != null
      ? matricula.toCompanion().copyWith(localId: Value(existing.localId!))
      : matricula.toCompanion();

    await _db.into(_db.matriculas).insertOnConflictUpdate(companion);
    
    _sync.syncLocalToCloud();
  }

  @override
  Future<void> deleteMatricula(String id) async {
    final matricula = await getMatriculaById(id);
    
    if (matricula != null) {
      await _db.transaction(() async {
        // 1. Soft Delete da Matrícula
        matricula.isDeleted = true;
        matricula.updatedAt = DateTime.now();
        matricula.syncStatus = SyncStatus.pendingSync;
        await _db.into(_db.matriculas).insertOnConflictUpdate(
          matricula.toCompanion().copyWith(localId: Value(matricula.localId!)),
        );

        // 2. Soft Delete SELETIVO de Mensalidades
        // Mantemos Pagas e Atrasadas. Removemos apenas as Pendentes futuras.
        final query = _db.select(_db.mensalidades)..where((t) => t.matriculaId.equals(id));
        final rows = await query.get();
        
        for (var row in rows) {
          if (row.estado == 'pendente') {
            final companion = row.toCompanion(true).copyWith(
              isDeleted: const Value(true),
              updatedAt: Value(DateTime.now()),
              syncStatus: const Value(SyncStatus.pendingSync),
            );
            await _db.update(_db.mensalidades).replace(companion);
          }
        }
      });

      _sync.syncLocalToCloud();
    }
  }

  @override
  Future<void> permanentDeleteMatricula(String id) async {
    await _sync.permanentDelete.hardDeleteMatriculaCascade(id);
  }

  @override
  Future<void> restoreMatricula(String id) async {
    final matricula = await getMatriculaById(id);
    if (matricula != null) {
      await (_db.update(_db.matriculas)..where((t) => t.id.equals(id))).write(
        MatriculasCompanion(
          isDeleted: const Value(false),
          updatedAt: Value(DateTime.now()),
          syncStatus: const Value(SyncStatus.pendingSync),
        ),
      );
      _sync.syncLocalToCloud();
    }
  }

  @override
  Future<Matricula?> getMatriculaById(String id) async {
    final query = _db.select(_db.matriculas)..where((t) => t.id.equals(id));
    final rows = await query.get();
    return rows.isNotEmpty ? rows.first.toEntity() : null;
  }
}
