import 'sync_entity.dart';

class Mensalidade implements SyncEntity {
  int? localId;

  @override
  late String id;

  late String matriculaId;
  late String alunoId;
  late String turmaId;
  late String turno;
  
  late int mesReferencia;
  late int anoReferencia;
  late double valor;
  late DateTime dataVencimento;
  late String estado;
  DateTime? dataPagamento;
  String? observacao;

  @override
  bool isDeleted = false; // Removido 'late'

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

  Mensalidade();
}
