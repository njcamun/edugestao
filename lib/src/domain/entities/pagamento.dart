import 'sync_entity.dart';

class Pagamento implements SyncEntity {
  int? localId;

  @override
  late String id;

  late String mensalidadeId;
  late double valorPago;
  late DateTime dataPagamento;
  late String formaPagamento; // 'Numerário', 'TPA', 'Transferência'
  String? observacao;
  
  String? evidenciaId; // Referência para EvidenciaPagamento
  late String numeroRecibo;
  late String confirmadoPor; // ID do utilizador (Admin/Geral)

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

  Pagamento();
}
