import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/providers/database_provider.dart';
import '../../core/services/audit_service.dart';
import '../../domain/entities/funcionario.dart';
import '../../domain/entities/sync_entity.dart';
import '../../domain/repositories/staff_repository.dart';
import '../../data/repositories/staff_repository_impl.dart';
import '../../data/sync/sync_service.dart';

final staffRepositoryProvider = Provider<StaffRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final audit = ref.watch(auditServiceProvider);
  final sync = ref.watch(syncServiceProvider);
  return StaffRepositoryImpl(db, audit, sync);
});

final staffStreamProvider = StreamProvider<List<Funcionario>>((ref) {
  return ref.watch(staffRepositoryProvider).watchFuncionarios();
});

final staffSearchProvider = StateProvider<String>((ref) => '');

final filteredStaffProvider = Provider<List<Funcionario>>((ref) {
  final list = ref.watch(staffStreamProvider).valueOrNull ?? [];
  final q = ref.watch(staffSearchProvider).toLowerCase();
  if (q.isEmpty) return list;
  return list
      .where((f) =>
          f.nomeCompleto.toLowerCase().contains(q) ||
          f.numeroFuncionario.toLowerCase().contains(q) ||
          f.cargo.toLowerCase().contains(q))
      .toList();
});

final staffActionsProvider = Provider<StaffActions>((ref) {
  return StaffActions(ref);
});

class StaffActions {
  final Ref _ref;
  final _uuid = const Uuid();

  StaffActions(this._ref);

  StaffRepository get _repo => _ref.read(staffRepositoryProvider);

  Future<void> save({
    Funcionario? existing,
    required String numero,
    required String nome,
    required String cargo,
    required String telefone,
    String? email,
    String? documento,
    required DateTime dataAdmissao,
    required double salarioBase,
    FuncionarioStatus status = FuncionarioStatus.ativo,
    String? observacoes,
  }) async {
    final f = existing ?? Funcionario();
    final now = DateTime.now();
    if (existing == null) {
      f.id = _uuid.v4();
      f.createdAt = now;
    }
    f.numeroFuncionario = numero;
    f.nomeCompleto = nome;
    f.cargo = cargo;
    f.telefone = telefone;
    f.email = email;
    f.documentoIdentidade = documento;
    f.dataAdmissao = dataAdmissao;
    f.salarioBase = salarioBase;
    f.status = status;
    f.observacoes = observacoes;
    f.updatedAt = now;
    f.syncStatus = SyncStatus.pendingSync;
    await _repo.save(f);
  }

  Future<void> delete(String id) => _repo.delete(id);

  Future<void> registrarPresenca(String id, bool presente) =>
      _repo.registrarPresenca(id, presente: presente);
}
