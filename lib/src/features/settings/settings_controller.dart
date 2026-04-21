import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/configuracao.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../core/providers/database_provider.dart';
import '../../data/sync/sync_service.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final syncService = ref.watch(syncServiceProvider);
  return SettingsRepositoryImpl(db, syncService);
});

final settingsProvider = StreamProvider<ConfiguracaoInstitucional?>((ref) {
  return ref.watch(settingsRepositoryProvider).watchConfig();
});
