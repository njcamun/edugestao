import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/mensalidade.dart';
import '../../domain/repositories/finance_repository.dart';
import '../../data/repositories/finance_repository_impl.dart';
import '../students/students_controller.dart';
import '../../core/providers/database_provider.dart';
import '../../core/services/audit_service.dart';
import '../../core/services/notification_service.dart';
import '../../data/sync/sync_service.dart';

final financeRepositoryProvider = Provider<FinanceRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final audit = ref.watch(auditServiceProvider);
  final notification = ref.watch(notificationServiceProvider);
  final sync = ref.watch(syncServiceProvider);
  
  return FinanceRepositoryImpl(db, audit, notification, sync);
});

final financeStreamProvider = StreamProvider<List<Mensalidade>>((ref) {
  final repo = ref.watch(financeRepositoryProvider);
  
  return repo.watchMensalidades().map((mensalidades) {
    final agora = DateTime.now();
    for (var m in mensalidades) {
      if (m.estado == 'pendente' && agora.isAfter(m.dataVencimento)) {
        m.estado = 'atrasado';
        m.updatedAt = agora;
        repo.saveMensalidade(m);
      }
    }
    return mensalidades.where((m) => !m.isDeleted).toList();
  });
});

final studentFinanceStreamProvider = StreamProvider.family<List<Mensalidade>, String>((ref, alunoId) {
  return ref.watch(financeRepositoryProvider).watchMensalidades().map((mensalidades) {
    return mensalidades.where((m) => m.alunoId == alunoId && !m.isDeleted).toList();
  });
});

// Filtros de Finanças com Mês Actual como Padrão
final financeSearchProvider = StateProvider<String>((ref) => '');
final financeMonthFilterProvider = StateProvider<int?>((ref) => DateTime.now().month); // Filtro inicial: Mês Actual
final financeYearFilterProvider = StateProvider<int?>((ref) => DateTime.now().year); // Filtro inicial: Ano Actual
final financeStatusFilterProvider = StateProvider<String?>((ref) => null);

final filteredFinanceProvider = Provider<List<Mensalidade>>((ref) {
  final mensalidadesAsync = ref.watch(financeStreamProvider);
  final search = ref.watch(financeSearchProvider).toLowerCase();
  final month = ref.watch(financeMonthFilterProvider);
  final year = ref.watch(financeYearFilterProvider);
  final status = ref.watch(financeStatusFilterProvider);
  final studentsAsync = ref.watch(studentsStreamProvider);

  return mensalidadesAsync.maybeWhen(
    data: (list) {
      return list.where((m) {
        if (m.isDeleted) return false;

        // Filtro por Mês
        if (month != null && m.mesReferencia != month) return false;
        
        // Filtro por Ano
        if (year != null && m.anoReferencia != year) return false;
        
        // Filtro por Status
        if (status != null && m.estado != status) return false;

        // Filtro por Nome de Aluno
        if (search.isNotEmpty) {
          final alunos = studentsAsync.value ?? [];
          final aluno = alunos.where((a) => a.id == m.alunoId).firstOrNull;
          if (aluno == null || !aluno.nomeCompleto.toLowerCase().contains(search)) return false;
        }

        return true;
      }).toList();
    },
    orElse: () => [],
  );
});
