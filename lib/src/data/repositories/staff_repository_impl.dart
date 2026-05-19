import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/funcionario.dart';
import '../../domain/entities/sync_entity.dart';
import '../../domain/repositories/staff_repository.dart';
import '../local/drift/app_database.dart';
import '../local/drift/mappers/funcionario_mapper.dart';
import '../../core/services/audit_service.dart';
import '../sync/sync_service.dart';

class StaffRepositoryImpl implements StaffRepository {
  final AppDatabase _db;
  final AuditService _audit;
  final SyncService _sync;
  final _uuid = const Uuid();

  StaffRepositoryImpl(this._db, this._audit, this._sync);

  @override
  Stream<List<Funcionario>> watchFuncionarios() {
    return (_db.select(_db.funcionarios)..where((t) => t.isDeleted.equals(false)))
        .watch()
        .map((rows) => rows.map((r) => r.toEntity()).toList());
  }

  @override
  Future<Funcionario?> getById(String id) async {
    final row = await (_db.select(_db.funcionarios)..where((t) => t.id.equals(id))).getSingleOrNull();
    return row?.toEntity();
  }

  @override
  Future<void> save(Funcionario funcionario) async {
    final existing = await getById(funcionario.id);
    final isNew = existing == null;

    funcionario.syncStatus = SyncStatus.pendingSync;
    funcionario.updatedAt = DateTime.now();

    final companion = existing != null
        ? funcionario.toCompanion().copyWith(localId: Value(existing.localId!))
        : funcionario.toCompanion();

    await _db.into(_db.funcionarios).insertOnConflictUpdate(companion);
    _sync.syncLocalToCloud();

    await _audit.log(
      entidade: 'Funcionario',
      entidadeId: funcionario.id,
      acao: isNew ? 'CREATE' : 'UPDATE',
      novo: {'nome': funcionario.nomeCompleto, 'cargo': funcionario.cargo},
    );
  }

  @override
  Future<void> delete(String id) async {
    final f = await getById(id);
    if (f == null) return;
    f.isDeleted = true;
    f.updatedAt = DateTime.now();
    f.syncStatus = SyncStatus.pendingSync;
    await _db.into(_db.funcionarios).insertOnConflictUpdate(
      f.toCompanion().copyWith(localId: Value(f.localId!)),
    );
    _sync.syncLocalToCloud();
    await _audit.log(entidade: 'Funcionario', entidadeId: id, acao: 'SOFT_DELETE');
  }

  @override
  Future<void> registrarPresenca(String funcionarioId, {required bool presente, String? observacao}) async {
    final now = DateTime.now();
    final presencaId = _uuid.v4();
    await _db.into(_db.presencasFuncionarios).insert(
      PresencasFuncionariosCompanion.insert(
        id: presencaId,
        funcionarioId: funcionarioId,
        data: now,
        presente: presente,
        observacao: Value(observacao),
      ),
    );
    await _sync.pushPresencaFuncionario(
      id: presencaId,
      funcionarioId: funcionarioId,
      data: now,
      presente: presente,
      observacao: observacao,
    );

    final f = await getById(funcionarioId);
    if (f != null && presente) {
      f.ultimaPresenca = now;
      f.updatedAt = now;
      await save(f);
    }
  }
}
