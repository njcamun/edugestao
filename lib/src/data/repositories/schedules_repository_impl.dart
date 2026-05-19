import 'package:drift/drift.dart';
import '../../domain/entities/horario_aula.dart';
import '../../domain/entities/sync_entity.dart';
import '../../domain/repositories/schedules_repository.dart';
import '../local/drift/app_database.dart';
import '../local/drift/mappers/horario_aula_mapper.dart';
import '../../core/services/audit_service.dart';
import '../sync/sync_service.dart';

class SchedulesRepositoryImpl implements SchedulesRepository {
  final AppDatabase _db;
  final AuditService _audit;
  final SyncService _sync;

  SchedulesRepositoryImpl(this._db, this._audit, this._sync);

  @override
  Future<List<HorarioAula>> listHorarios(String turmaId) async {
    final rows = await (_db.select(_db.horariosAula)
          ..where((t) => t.isDeleted.equals(false) & t.turmaId.equals(turmaId)))
        .get();
    return rows.map((r) => r.toEntity()).toList();
  }

  @override
  Future<List<HorarioAula>> listAllHorarios() async {
    final rows = await (_db.select(_db.horariosAula)..where((t) => t.isDeleted.equals(false))).get();
    return rows.map((r) => r.toEntity()).toList();
  }

  @override
  Stream<List<HorarioAula>> watchHorarios(String turmaId) {
    final query = _db.select(_db.horariosAula)
      ..where((t) => t.isDeleted.equals(false) & t.turmaId.equals(turmaId))
      ..orderBy([
        (t) => OrderingTerm(expression: t.diaSemana),
        (t) => OrderingTerm(expression: t.horaInicio),
      ]);
    return query.watch().map((rows) => rows.map((r) => r.toEntity()).toList());
  }

  Future<HorarioAula?> _getById(String id) async {
    final row = await (_db.select(_db.horariosAula)..where((t) => t.id.equals(id))).getSingleOrNull();
    return row?.toEntity();
  }

  @override
  Future<void> save(HorarioAula horario) async {
    final existing = await _getById(horario.id);
    horario.syncStatus = SyncStatus.pendingSync;
    horario.updatedAt = DateTime.now();

    final companion = existing != null
        ? horario.toCompanion().copyWith(localId: Value(existing.localId!))
        : horario.toCompanion();

    await _db.into(_db.horariosAula).insertOnConflictUpdate(companion);
    _sync.syncLocalToCloud();

    await _audit.log(
      entidade: 'HorarioAula',
      entidadeId: horario.id,
      acao: existing == null ? 'CREATE' : 'UPDATE',
      novo: {'turma': horario.turmaId, 'disciplina': horario.disciplina},
    );
  }

  @override
  Future<void> delete(String id) async {
    final existing = await _getById(id);
    if (existing == null) return;
    existing.isDeleted = true;
    existing.updatedAt = DateTime.now();
    existing.syncStatus = SyncStatus.pendingSync;
    await _db.into(_db.horariosAula).insertOnConflictUpdate(
          existing.toCompanion().copyWith(localId: Value(existing.localId!)),
        );
    _sync.syncLocalToCloud();
    await _audit.log(entidade: 'HorarioAula', entidadeId: id, acao: 'DELETE');
  }
}
