import '../../domain/entities/configuracao.dart';
import '../../domain/entities/sync_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../local/drift/app_database.dart';
import '../local/drift/mappers/config_mapper.dart';
import '../sync/sync_service.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final AppDatabase _db;
  final SyncService _sync;

  SettingsRepositoryImpl(this._db, this._sync);

  @override
  Future<ConfiguracaoInstitucional?> getConfig() async {
    final query = _db.select(_db.configuracoes)..where((t) => t.localId.equals(1));
    final row = await query.getSingleOrNull();
    return row?.toEntity();
  }

  @override
  Future<void> saveConfig(ConfiguracaoInstitucional config) async {
    config.updatedAt = DateTime.now();
    config.syncStatus = SyncStatus.pendingSync;
    
    // Forçar localId 1 para garantir registro único de configuração
    config.localId = 1;

    await _db.into(_db.configuracoes).insertOnConflictUpdate(config.toCompanion());
    
    _sync.syncLocalToCloud();
  }

  @override
  Stream<ConfiguracaoInstitucional?> watchConfig() {
    final query = _db.select(_db.configuracoes)..where((t) => t.localId.equals(1));
    return query.watchSingleOrNull().map((row) => row?.toEntity());
  }
}
