import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/aluno.dart';
import '../../domain/entities/utilizador.dart';
import '../../domain/repositories/student_repository.dart';
import '../../data/repositories/student_repository_impl.dart';
import '../../core/providers/database_provider.dart';
import '../../core/services/audit_service.dart';
import '../../core/services/notification_service.dart';
import '../../data/sync/sync_service.dart';
import '../../state/session.dart';

final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final audit = ref.watch(auditServiceProvider);
  final notification = ref.watch(notificationServiceProvider);
  final syncService = ref.watch(syncServiceProvider);
  
  return StudentRepositoryImpl(db, audit, notification, syncService);
});

final studentsStreamProvider = StreamProvider<List<Aluno>>((ref) {
  final repo = ref.watch(studentRepositoryProvider);
  final session = ref.watch(sessionProvider);
  
  // Se for ADMIN, ele pode ver tudo (incluindo deletados)
  if (session.perfil?.perfil == Perfil.admin) {
    return repo.watchAlunosAdmin(); // Novo método no repo
  }
  
  return repo.watchAlunos();
});

final studentSearchProvider = StateProvider<String>((ref) => '');

final filteredStudentsProvider = Provider<List<Aluno>>((ref) {
  final studentsAsync = ref.watch(studentsStreamProvider);
  final search = ref.watch(studentSearchProvider).toLowerCase();

  return studentsAsync.maybeWhen(
    data: (students) {
      if (search.isEmpty) return students;
      return students.where((aluno) => 
        aluno.nomeCompleto.toLowerCase().contains(search) ||
        aluno.numeroAluno.toLowerCase().contains(search)
      ).toList();
    },
    orElse: () => [],
  );
});
