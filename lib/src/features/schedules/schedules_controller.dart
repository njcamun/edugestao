import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/providers/database_provider.dart';
import '../../core/services/audit_service.dart';
import '../../domain/entities/horario_aula.dart';
import '../../domain/entities/sync_entity.dart';
import '../../domain/repositories/schedules_repository.dart';
import '../../data/repositories/schedules_repository_impl.dart';
import '../../data/sync/sync_service.dart';
import '../classes/classes_controller.dart';
import 'utils/schedule_conflict_checker.dart';

class ScheduleConflictException implements Exception {
  ScheduleConflictException(this.message);
  final String message;
  @override
  String toString() => message;
}

final schedulesRepositoryProvider = Provider<SchedulesRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final audit = ref.watch(auditServiceProvider);
  final sync = ref.watch(syncServiceProvider);
  return SchedulesRepositoryImpl(db, audit, sync);
});

enum ScheduleViewMode { lista, semana }

final scheduleViewModeProvider = StateProvider.family<ScheduleViewMode, String>((ref, _) => ScheduleViewMode.lista);

final horariosTurmaProvider = StreamProvider.family<List<HorarioAula>, String>((ref, turmaId) {
  return ref.watch(schedulesRepositoryProvider).watchHorarios(turmaId);
});

final scheduleActionsProvider = Provider<ScheduleActions>((ref) => ScheduleActions(ref));

/// Conflitos na mesma sala (inclui outras turmas que usam a sala).
typedef ScheduleConflicts = ({Set<String> ids, List<String> messages, List<String> professorMessages});

final scheduleConflictsProvider = FutureProvider.family<ScheduleConflicts, String>((ref, turmaId) async {
  final actions = ref.read(scheduleActionsProvider);
  return actions.loadConflicts(turmaId);
});

class ScheduleActions {
  final Ref _ref;
  final _uuid = const Uuid();

  ScheduleActions(this._ref);

  SchedulesRepository get _repo => _ref.read(schedulesRepositoryProvider);

  Future<List<HorarioAula>> _horariosMesmaSala(String turmaId) async {
    final turmas = _ref.read(classesStreamProvider).valueOrNull ?? [];
    final matches = turmas.where((t) => t.id == turmaId);
    if (matches.isEmpty) return [];
    final sala = matches.first.numeroSala;
    final turmaIds = turmas.where((t) => !t.isDeleted && t.numeroSala == sala).map((t) => t.id);
    final all = <HorarioAula>[];
    for (final tid in turmaIds) {
      all.addAll(await _repo.listHorarios(tid));
    }
    return all;
  }

  Future<ScheduleConflicts> loadConflicts(String turmaId) async {
    final salaHorarios = await _horariosMesmaSala(turmaId);
    final salaIds = ScheduleConflictChecker.conflictingIds(salaHorarios);
    final salaMsg = ScheduleConflictChecker.describeConflicts(salaHorarios);

    final all = await _repo.listAllHorarios();
    final profIds = ScheduleConflictChecker.professorConflictingIds(all);
    final profMsg = ScheduleConflictChecker.describeProfessorConflicts(all);

    final turmaIds = (await _repo.listHorarios(turmaId)).map((h) => h.id).toSet();
    final visibleProf = profIds.where(turmaIds.contains).toSet();

    return (
      ids: {...salaIds, ...visibleProf},
      messages: salaMsg,
      professorMessages: profMsg,
    );
  }

  Future<String?> findConflict({
    required String turmaId,
    required int diaSemana,
    required String horaInicio,
    required String horaFim,
    String? ignoreHorarioId,
  }) async {
    final turmas = _ref.read(classesStreamProvider).valueOrNull ?? [];
    final matches = turmas.where((t) => t.id == turmaId);
    if (matches.isEmpty) return null;
    final turma = matches.first;

    final sala = turma.numeroSala;
    final turmaIds = turmas.where((t) => !t.isDeleted && t.numeroSala == sala).map((t) => t.id);

    final existentes = <HorarioAula>[];
    for (final tid in turmaIds) {
      existentes.addAll(await _repo.listHorarios(tid));
    }

    return ScheduleConflictChecker.findConflict(
      existentes: existentes,
      diaSemana: diaSemana,
      horaInicio: horaInicio,
      horaFim: horaFim,
      ignoreHorarioId: ignoreHorarioId,
      salaLabel: sala,
    );
  }

  Future<void> save({
    HorarioAula? existing,
    required String turmaId,
    required int diaSemana,
    required String horaInicio,
    required String horaFim,
    required String disciplina,
    String? professor,
  }) async {
    final conflict = await findConflict(
      turmaId: turmaId,
      diaSemana: diaSemana,
      horaInicio: horaInicio,
      horaFim: horaFim,
      ignoreHorarioId: existing?.id,
    );
    if (conflict != null) throw ScheduleConflictException(conflict);

    final prof = professor?.trim();
    if (prof != null && prof.isNotEmpty) {
      final all = await _repo.listAllHorarios();
      final profConflict = ScheduleConflictChecker.findProfessorConflict(
        existentes: all,
        diaSemana: diaSemana,
        horaInicio: horaInicio,
        horaFim: horaFim,
        professor: prof,
        ignoreHorarioId: existing?.id,
      );
      if (profConflict != null) throw ScheduleConflictException(profConflict);
    }

    final now = DateTime.now();
    final h = existing ?? HorarioAula();
    if (existing == null) {
      h.id = _uuid.v4();
      h.createdAt = now;
      h.isDeleted = false;
    }
    h
      ..turmaId = turmaId
      ..diaSemana = diaSemana
      ..horaInicio = horaInicio
      ..horaFim = horaFim
      ..disciplina = disciplina.trim()
      ..professor = professor?.trim().isEmpty == true ? null : professor?.trim()
      ..updatedAt = now
      ..syncStatus = SyncStatus.pendingSync;

    await _repo.save(h);
    _ref.invalidate(scheduleConflictsProvider(turmaId));
  }

  Future<void> delete(String id, {required String turmaId}) async {
    await _repo.delete(id);
    _ref.invalidate(scheduleConflictsProvider(turmaId));
  }
}
