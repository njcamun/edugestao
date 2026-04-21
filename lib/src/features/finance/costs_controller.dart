import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/custo.dart';
import '../../domain/repositories/costs_repository.dart';
import '../../data/repositories/costs_repository_impl.dart';
import '../../core/providers/database_provider.dart';
import '../../core/services/audit_service.dart';
import '../../data/sync/sync_service.dart';
import '../../state/session.dart';
import '../../domain/entities/utilizador.dart';

final costsRepositoryProvider = Provider<CostsRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final audit = ref.watch(auditServiceProvider);
  final sync = ref.watch(syncServiceProvider);
  return CostsRepositoryImpl(db, audit, sync);
});

final costsStreamProvider = StreamProvider<List<CustoMensal>>((ref) {
  final repo = ref.watch(costsRepositoryProvider);
  final session = ref.watch(sessionProvider);
  final isAdmin = session.perfil?.perfil == Perfil.admin;

  return isAdmin ? repo.watchCustosAdmin() : repo.watchCustos();
});

// Filtros para o Inventário de Custos
final costsTypeFilterProvider = StateProvider<String>((ref) => 'TODOS'); // TODOS, FIXOS, VARIAVEIS
final costsMonthFilterProvider = StateProvider<int?>((ref) => DateTime.now().month);
final costsYearFilterProvider = StateProvider<int?>((ref) => DateTime.now().year);

final filteredCostsProvider = Provider<List<CustoMensal>>((ref) {
  final costsAsync = ref.watch(costsStreamProvider);
  final typeFilter = ref.watch(costsTypeFilterProvider);
  final monthFilter = ref.watch(costsMonthFilterProvider);
  final yearFilter = ref.watch(costsYearFilterProvider);
  final session = ref.watch(sessionProvider);
  final isAdmin = session.perfil?.perfil == Perfil.admin;

  return costsAsync.maybeWhen(
    data: (list) {
      return list.where((c) {
        // 1. Filtrar removidos se não for Admin
        if (!isAdmin && c.isDeleted) return false;

        // 2. Filtro por Mês de Referência
        if (monthFilter != null && c.mesReferencia != monthFilter) return false;
        
        // 3. Filtro por Ano de Referência
        if (yearFilter != null && c.anoReferencia != yearFilter) return false;

        // 4. Filtro por Tipo (Usa a propriedade 'tipo' da entidade)
        if (typeFilter == 'FIXOS') {
          if (c.tipo != 'FIXO') return false;
        } else if (typeFilter == 'VARIAVEIS') {
          if (c.tipo != 'VARIAVEL') return false;
        }

        return true;
      }).toList();
    },
    orElse: () => [],
  );
});
