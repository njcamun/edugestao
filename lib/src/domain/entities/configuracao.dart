import 'sync_entity.dart';

class ConfiguracaoInstitucional implements SyncEntity {
  int? localId; // Singleton: apenas um registo no dispositivo

  @override
  late String id; // ID Global para sincronização

  late String nomeInstituicao;
  String? logotipoUrl;
  late String morada;
  late String telefone;
  late String email;
  late String nif;
  
  late String moedaPadrao; // 'Kz'
  late String textoRodapeRelatorio;
  late String reciboPrefixo; // 'REC-'

  @override
  bool isDeleted = false;

  @override
  late DateTime createdAt;
  @override
  late DateTime updatedAt;
  @override
  late SyncStatus syncStatus;
  @override
  String? createdBy;
  @override
  String? updatedBy;

  ConfiguracaoInstitucional();
}
