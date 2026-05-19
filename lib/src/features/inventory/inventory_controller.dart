import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/providers/database_provider.dart';
import '../../core/services/audit_service.dart';
import '../../domain/entities/ativo_inventario.dart';
import '../../domain/entities/sync_entity.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../../data/repositories/inventory_repository_impl.dart';
import '../../data/sync/sync_service.dart';

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final audit = ref.watch(auditServiceProvider);
  final sync = ref.watch(syncServiceProvider);
  return InventoryRepositoryImpl(db, audit, sync);
});

final inventoryStreamProvider = StreamProvider<List<AtivoInventario>>((ref) {
  return ref.watch(inventoryRepositoryProvider).watchAtivos();
});

final inventorySearchProvider = StateProvider<String>((ref) => '');

final inventoryFilterEstadoProvider = StateProvider<AtivoEstado?>((ref) => null);

final filteredInventoryProvider = Provider<List<AtivoInventario>>((ref) {
  var list = ref.watch(inventoryStreamProvider).valueOrNull ?? [];
  final q = ref.watch(inventorySearchProvider).toLowerCase();
  final estado = ref.watch(inventoryFilterEstadoProvider);

  if (estado != null) {
    list = list.where((a) => a.estado == estado).toList();
  }
  if (q.isNotEmpty) {
    list = list
        .where((a) =>
            a.nome.toLowerCase().contains(q) ||
            a.codigo.toLowerCase().contains(q) ||
            a.localizacao.toLowerCase().contains(q) ||
            a.categoria.toLowerCase().contains(q))
        .toList();
  }
  return list;
});

final manutencoesProvider = StreamProvider.family<List<ManutencaoAtivo>, String>((ref, ativoId) {
  return ref.watch(inventoryRepositoryProvider).watchManutencoes(ativoId);
});

final inventoryActionsProvider = Provider<InventoryActions>((ref) => InventoryActions(ref));

class InventoryActions {
  final Ref _ref;
  final _uuid = const Uuid();

  InventoryActions(this._ref);

  InventoryRepository get _repo => _ref.read(inventoryRepositoryProvider);

  Future<void> saveAtivo({
    AtivoInventario? existing,
    required String codigo,
    required String nome,
    required String categoria,
    required String localizacao,
    required AtivoEstado estado,
    required double valorAquisicao,
    required DateTime dataAquisicao,
    String? observacoes,
  }) async {
    final a = existing ?? AtivoInventario();
    final now = DateTime.now();
    if (existing == null) {
      a.id = _uuid.v4();
      a.createdAt = now;
    }
    a.codigo = codigo;
    a.nome = nome;
    a.categoria = categoria;
    a.localizacao = localizacao;
    a.estado = estado;
    a.valorAquisicao = valorAquisicao;
    a.dataAquisicao = dataAquisicao;
    a.observacoes = observacoes;
    a.updatedAt = now;
    a.syncStatus = SyncStatus.pendingSync;
    await _repo.saveAtivo(a);
  }

  Future<void> deleteAtivo(String id) => _repo.deleteAtivo(id);

  Future<void> registrarManutencao({
    required String ativoId,
    required String descricao,
    required double custo,
    String? realizadoPor,
  }) async {
    final m = ManutencaoAtivo()
      ..id = _uuid.v4()
      ..ativoId = ativoId
      ..data = DateTime.now()
      ..descricao = descricao
      ..custo = custo
      ..realizadoPor = realizadoPor;
    await _repo.registrarManutencao(m);
  }
}
