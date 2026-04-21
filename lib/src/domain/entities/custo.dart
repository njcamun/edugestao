import 'sync_entity.dart';

class CustoMensal implements SyncEntity {
  int? localId;

  @override
  late String id;

  late String descricao;
  late String categoria; 
  late double valor;
  late DateTime data;
  
  late String tipo; // 'FIXO', 'VARIAVEL'
  late int mesReferencia;
  late int anoReferencia;
  
  late String estado; // 'PENDENTE', 'PAGO'

  String? observacao;
  String? comprovativoUrl;
  String? comprovativoLocal;
  late String responsavelId;

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

  CustoMensal();
}
