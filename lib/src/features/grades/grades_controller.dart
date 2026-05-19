import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/providers/database_provider.dart';
import '../../core/services/audit_service.dart';
import '../../domain/entities/nota_avaliacao.dart';
import '../../domain/entities/sync_entity.dart';
import '../../domain/repositories/grades_repository.dart';
import '../../data/repositories/grades_repository_impl.dart';
import '../../data/sync/sync_service.dart';

final gradesRepositoryProvider = Provider<GradesRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final audit = ref.watch(auditServiceProvider);
  final sync = ref.watch(syncServiceProvider);
  return GradesRepositoryImpl(db, audit, sync);
});

enum GradesViewMode { notas, resumoAlunos }

final gradesViewModeProvider = StateProvider<GradesViewMode>((ref) => GradesViewMode.notas);

final gradesFilterProvider = StateProvider<({int trimestre, String disciplina, String anoLectivo})>((ref) {
  return (trimestre: 1, disciplina: '', anoLectivo: DateTime.now().year.toString());
});

final gradesStreamProvider = StreamProvider<List<NotaAvaliacao>>((ref) {
  final filter = ref.watch(gradesFilterProvider);
  return ref.watch(gradesRepositoryProvider).watchNotas(
        trimestre: filter.trimestre,
        anoLectivo: filter.anoLectivo.isEmpty ? null : filter.anoLectivo,
        disciplina: filter.disciplina.isEmpty ? null : filter.disciplina,
      );
});

final gradeActionsProvider = Provider<GradeActions>((ref) => GradeActions(ref));

class GradeActions {
  final Ref _ref;
  final _uuid = const Uuid();

  GradeActions(this._ref);

  GradesRepository get _repo => _ref.read(gradesRepositoryProvider);

  Future<void> save({
    NotaAvaliacao? existing,
    required String alunoId,
    required String disciplina,
    required int trimestre,
    required String anoLectivo,
    required double valor,
    String? observacao,
  }) async {
    final now = DateTime.now();
    final nota = existing ?? NotaAvaliacao();
    if (existing == null) {
      nota.id = _uuid.v4();
      nota.createdAt = now;
      nota.isDeleted = false;
    }
    nota
      ..alunoId = alunoId
      ..disciplina = disciplina.trim()
      ..trimestre = trimestre
      ..anoLectivo = anoLectivo
      ..valor = valor
      ..observacao = observacao?.trim().isEmpty == true ? null : observacao?.trim()
      ..updatedAt = now
      ..syncStatus = SyncStatus.pendingSync;

    await _repo.save(nota);
  }

  Future<void> delete(String id) => _repo.delete(id);
}
