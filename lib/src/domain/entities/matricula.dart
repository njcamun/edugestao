import 'sync_entity.dart';

class Matricula implements SyncEntity {
  int? localId;

  @override
  late String id;

  late String numeroMatricula;
  late String alunoId;
  late String turmaId;
  late String turno;
  late String anoLectivo;
  late DateTime dataMatricula;
  late String estado;
  
  late double valorMensalidade;
  late int diaVencimento;

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

  Matricula();
}
