import 'package:drift/drift.dart';
import '../../domain/entities/aluno.dart';
import '../../domain/entities/sync_entity.dart';
import '../../domain/repositories/student_repository.dart';
import '../local/drift/app_database.dart';
import '../local/drift/mappers/aluno_mapper.dart';
import '../../core/services/audit_service.dart';
import '../../core/services/notification_service.dart';
import '../sync/sync_service.dart';

class StudentRepositoryImpl implements StudentRepository {
  final AppDatabase _db;
  final AuditService _audit;
  final NotificationService _notification;
  final SyncService _sync;

  StudentRepositoryImpl(this._db, this._audit, this._notification, this._sync);

  @override
  Stream<List<Aluno>> watchAlunos() {
    return (_db.select(_db.alunos)..where((t) => t.isDeleted.equals(false)))
        .watch()
        .map((rows) => rows.map((row) => row.toEntity()).toList());
  }

  @override
  Stream<List<Aluno>> watchAlunosAdmin() {
    // Admin vê todos, incluindo os marcados como isDeleted
    return (_db.select(_db.alunos)..orderBy([(t) => OrderingTerm(expression: t.nomeCompleto)]))
        .watch()
        .map((rows) => rows.map((row) => row.toEntity()).toList());
  }

  @override
  Future<void> saveAluno(Aluno aluno) async {
    final existing = await getAlunoById(aluno.id);
    final isNew = existing == null;

    aluno.syncStatus = SyncStatus.pendingSync;
    aluno.updatedAt = DateTime.now();

    final companion = existing != null
      ? aluno.toCompanion().copyWith(localId: Value(existing.localId!))
      : aluno.toCompanion();

    await _db.into(_db.alunos).insertOnConflictUpdate(companion);

    _sync.syncLocalToCloud();

    await _audit.log(
      entidade: 'Aluno',
      entidadeId: aluno.id,
      acao: isNew ? 'CREATE' : 'UPDATE',
      novo: {'nome': aluno.nomeCompleto},
    );

    if (isNew) {
      await _notification.notify(
        titulo: 'Novo Aluno Registado',
        mensagem: '${aluno.nomeCompleto} foi adicionado ao sistema.',
        tipo: 'success',
        entidadeRelacionada: 'Aluno',
        entidadeId: aluno.id,
      );
    }
  }

  @override
  Future<void> deleteAluno(String id) async {
    final query = _db.select(_db.matriculas)..where((t) => t.alunoId.equals(id) & t.isDeleted.equals(false));
    final matriculas = await query.get();
    
    if (matriculas.isNotEmpty) {
      throw Exception('NÃO É POSSÍVEL REMOVER O ALUNO. EXISTEM MATRÍCULAS ACTIVAS ASSOCIADAS.');
    }

    final aluno = await getAlunoById(id);
    if (aluno != null) {
      aluno.isDeleted = true;
      aluno.updatedAt = DateTime.now();
      aluno.syncStatus = SyncStatus.pendingSync;

      await _db.into(_db.alunos).insertOnConflictUpdate(
        aluno.toCompanion().copyWith(localId: Value(aluno.localId!)),
      );

      _sync.syncLocalToCloud();
      await _audit.log(entidade: 'Aluno', entidadeId: id, acao: 'SOFT_DELETE', anterior: {'nome': aluno.nomeCompleto});
    }
  }

  @override
  Future<void> permanentDeleteAluno(String id) async {
    // 1. Obter todas as mensalidades do aluno para poder apagar pagamentos vinculados
    final mensalidadesQuery = _db.select(_db.mensalidades)..where((t) => t.alunoId.equals(id));
    final mensalidades = await mensalidadesQuery.get();
    final mensalidadeIds = mensalidades.map((m) => m.id).toList();

    await _db.transaction(() async {
      // 2. Apagar Pagamentos vinculados às mensalidades do aluno
      if (mensalidadeIds.isNotEmpty) {
        for (final mid in mensalidadeIds) {
          final pagamentosQuery = _db.select(_db.pagamentos)..where((t) => t.mensalidadeId.equals(mid));
          final pagamentos = await pagamentosQuery.get();
          
          for (final p in pagamentos) {
            await (_db.delete(_db.pagamentos)..where((t) => t.id.equals(p.id))).go();
            _sync.deleteFromCloud('pagamentos', p.id);
          }
        }
      }

      // 3. Apagar Mensalidades
      await (_db.delete(_db.mensalidades)..where((t) => t.alunoId.equals(id))).go();
      for (final mid in mensalidadeIds) {
        _sync.deleteFromCloud('mensalidades', mid);
      }

      // 4. Apagar Matrículas
      final matriculasQuery = _db.select(_db.matriculas)..where((t) => t.alunoId.equals(id));
      final matriculas = await matriculasQuery.get();
      await (_db.delete(_db.matriculas)..where((t) => t.alunoId.equals(id))).go();
      for (final mat in matriculas) {
        _sync.deleteFromCloud('matriculas', mat.id);
      }

      // 5. Apagar o Aluno
      await (_db.delete(_db.alunos)..where((t) => t.id.equals(id))).go();
      _sync.deleteFromCloud('alunos', id);
    });

    await _audit.log(
      entidade: 'Aluno',
      entidadeId: id,
      acao: 'HARD_DELETE',
      anterior: {'msg': 'Remoção completa do aluno e dependentes.'},
    );
  }

  @override
  Future<void> restoreAluno(String id) async {
    final aluno = await getAlunoById(id);
    if (aluno != null) {
      aluno.isDeleted = false;
      aluno.updatedAt = DateTime.now();
      aluno.syncStatus = SyncStatus.pendingSync;
      await _db.into(_db.alunos).insertOnConflictUpdate(
        aluno.toCompanion().copyWith(localId: Value(aluno.localId!)),
      );
      _sync.syncLocalToCloud();
    }
  }

  @override
  Future<Aluno?> getAlunoById(String id) async {
    final query = _db.select(_db.alunos)..where((t) => t.id.equals(id));
    final rows = await query.get();
    return rows.isNotEmpty ? rows.first.toEntity() : null;
  }
}
