import 'sync_entity.dart';

enum FuncionarioStatus { ativo, inativo, licenca }

class Funcionario implements SyncEntity {
  int? localId;

  @override
  late String id;

  late String numeroFuncionario;
  late String nomeCompleto;
  late String cargo;
  String? email;
  late String telefone;
  String? documentoIdentidade;
  late DateTime dataAdmissao;
  late double salarioBase;
  late FuncionarioStatus status;
  DateTime? ultimaPresenca;
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

  Funcionario();
}
