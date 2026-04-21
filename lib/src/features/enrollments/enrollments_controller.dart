import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/matricula.dart';
import '../../domain/repositories/enrollment_repository.dart';
import '../../data/repositories/enrollment_repository_impl.dart';
import '../../core/providers/database_provider.dart';
import '../../data/sync/sync_service.dart';
import '../../state/session.dart';
import '../../domain/entities/utilizador.dart';

final enrollmentRepositoryProvider = Provider<EnrollmentRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final syncService = ref.watch(syncServiceProvider);
  return EnrollmentRepositoryImpl(db, syncService);
});

final enrollmentsStreamProvider = StreamProvider<List<Matricula>>((ref) {
  final repo = ref.watch(enrollmentRepositoryProvider);
  final session = ref.watch(sessionProvider);
  if (session.perfil?.perfil == Perfil.admin) {
    return repo.watchMatriculasAdmin();
  }
  return repo.watchMatriculas();
});
