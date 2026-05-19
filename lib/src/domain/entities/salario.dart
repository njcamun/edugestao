import 'sync_entity.dart';

enum SalarioEstado { pendente, pago, cancelado }

class Salario implements SyncEntity {
  int? localId;

  @override
  late String id;

  late String funcionarioId;
  late String funcionarioNome;
  late int mesReferencia;
  late int anoReferencia;
  late double valorBase;
  late double descontos;
  late double bonus;
  late double valorLiquido;
  late SalarioEstado estado;
  DateTime? dataPagamento;
  String? observacao;

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

  Salario();

  static double calcularLiquido(double base, double descontos, double bonus) =>
      base - descontos + bonus;
}
