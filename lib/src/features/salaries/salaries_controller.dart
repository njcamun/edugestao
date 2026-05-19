import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/providers/database_provider.dart';
import '../../core/services/audit_service.dart';
import '../../domain/entities/funcionario.dart';
import '../../domain/entities/salario.dart';
import '../../domain/entities/sync_entity.dart';
import '../../domain/repositories/salary_repository.dart';
import '../../data/repositories/salary_repository_impl.dart';
import '../../data/sync/sync_service.dart';
import '../staff/staff_controller.dart';

final salaryRepositoryProvider = Provider<SalaryRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final audit = ref.watch(auditServiceProvider);
  final sync = ref.watch(syncServiceProvider);
  return SalaryRepositoryImpl(db, audit, sync);
});

final salaryFilterProvider = StateProvider<({int mes, int ano})>((ref) {
  final now = DateTime.now();
  return (mes: now.month, ano: now.year);
});

final salariesStreamProvider = StreamProvider<List<Salario>>((ref) {
  final filter = ref.watch(salaryFilterProvider);
  return ref.watch(salaryRepositoryProvider).watchSalarios(mes: filter.mes, ano: filter.ano);
});

final pendingSalariesCountProvider = Provider<int>((ref) {
  final list = ref.watch(salariesStreamProvider).valueOrNull ?? [];
  return list.where((s) => s.estado == SalarioEstado.pendente).length;
});

final salaryActionsProvider = Provider<SalaryActions>((ref) => SalaryActions(ref));

class SalaryActions {
  final Ref _ref;
  final _uuid = const Uuid();

  SalaryActions(this._ref);

  SalaryRepository get _repo => _ref.read(salaryRepositoryProvider);

  Future<void> processar({
    required String funcionarioId,
    required String funcionarioNome,
    required double valorBase,
    double descontos = 0,
    double bonus = 0,
    String? observacao,
  }) async {
    final filter = _ref.read(salaryFilterProvider);
    final now = DateTime.now();
    final s = Salario()
      ..id = _uuid.v4()
      ..funcionarioId = funcionarioId
      ..funcionarioNome = funcionarioNome
      ..mesReferencia = filter.mes
      ..anoReferencia = filter.ano
      ..valorBase = valorBase
      ..descontos = descontos
      ..bonus = bonus
      ..estado = SalarioEstado.pendente
      ..observacao = observacao
      ..createdAt = now
      ..updatedAt = now
      ..syncStatus = SyncStatus.pendingSync;

    await _repo.save(s);
  }

  Future<void> marcarPago(String id) => _repo.marcarComoPago(id);

  Future<void> delete(String id) => _repo.delete(id);
}

Future<void> gerarFolhaMensal(WidgetRef ref) async {
  final staff = ref.read(staffStreamProvider).valueOrNull ?? [];
  final existing = ref.read(salariesStreamProvider).valueOrNull ?? [];
  final actions = ref.read(salaryActionsProvider);

  for (final f in staff.where((x) => x.status == FuncionarioStatus.ativo)) {
    final jaExiste = existing.any((s) => s.funcionarioId == f.id);
    if (jaExiste) continue;
    await actions.processar(
      funcionarioId: f.id,
      funcionarioNome: f.nomeCompleto,
      valorBase: f.salarioBase,
    );
  }
}
