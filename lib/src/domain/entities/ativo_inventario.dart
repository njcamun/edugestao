import 'sync_entity.dart';

enum AtivoEstado { bom, regular, avariado, emManutencao, abatido }

class AtivoInventario implements SyncEntity {
  int? localId;

  @override
  late String id;

  late String codigo;
  late String nome;
  late String categoria;
  late String localizacao;
  late AtivoEstado estado;
  late double valorAquisicao;
  late DateTime dataAquisicao;
  DateTime? ultimaManutencao;
  String? observacoes;

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

  AtivoInventario();
}

class ManutencaoAtivo {
  int? localId;
  late String id;
  late String ativoId;
  late DateTime data;
  late String descricao;
  late double custo;
  String? realizadoPor;

  ManutencaoAtivo();
}
