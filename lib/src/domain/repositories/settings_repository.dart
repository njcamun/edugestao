import '../entities/configuracao.dart';

abstract class SettingsRepository {
  Future<ConfiguracaoInstitucional?> getConfig();
  Future<void> saveConfig(ConfiguracaoInstitucional config);
  Stream<ConfiguracaoInstitucional?> watchConfig();
}
