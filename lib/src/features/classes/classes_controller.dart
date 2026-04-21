import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/turma.dart';
import '../../domain/entities/utilizador.dart';
import '../../domain/repositories/classes_repository.dart';
import '../../data/repositories/classes_repository_impl.dart';
import '../../core/providers/database_provider.dart';
import '../../data/sync/sync_service.dart';
import '../../state/session.dart';

final classesRepositoryProvider = Provider<ClassesRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final syncService = ref.watch(syncServiceProvider);
  return ClassesRepositoryImpl(db, syncService);
});

final classesStreamProvider = StreamProvider<List<Turma>>((ref) {
  final repo = ref.watch(classesRepositoryProvider);
  final session = ref.watch(sessionProvider);
  
  if (session.perfil?.perfil == Perfil.admin) {
    return repo.watchTurmasAdmin();
  }
  return repo.watchTurmas();
});
