import 'sync_entity.dart';

class Turma implements SyncEntity {
  int? localId;

  @override
  late String id;

  late String nomeTurma;
  late int limiteAlunos;
  late String turno;
  late String numeroSala;
  late bool ativa;

  late String anoLectivoId; // Referência obrigatória ao Ano Lectivo

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

  Turma();
}
