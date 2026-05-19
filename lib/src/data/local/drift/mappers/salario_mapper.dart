import 'package:drift/drift.dart';
import 'package:edugestao/src/data/local/drift/app_database.dart';
import 'package:edugestao/src/domain/entities/salario.dart';

extension SalarioMapper on Salario {
  SalariosCompanion toCompanion() {
    return SalariosCompanion.insert(
      id: id,
      funcionarioId: funcionarioId,
      funcionarioNome: funcionarioNome,
      mesReferencia: mesReferencia,
      anoReferencia: anoReferencia,
      valorBase: valorBase,
      descontos: descontos,
      bonus: bonus,
      valorLiquido: valorLiquido,
      estado: estado,
      dataPagamento: Value(dataPagamento),
      observacao: Value(observacao),
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncStatus: syncStatus,
      createdBy: Value(createdBy),
      updatedBy: Value(updatedBy),
      isDeleted: Value(isDeleted),
    );
  }
}

extension SalarioDataMapper on SalarioData {
  Salario toEntity() {
    return Salario()
      ..localId = localId
      ..id = id
      ..funcionarioId = funcionarioId
      ..funcionarioNome = funcionarioNome
      ..mesReferencia = mesReferencia
      ..anoReferencia = anoReferencia
      ..valorBase = valorBase
      ..descontos = descontos
      ..bonus = bonus
      ..valorLiquido = valorLiquido
      ..estado = estado
      ..dataPagamento = dataPagamento
      ..observacao = observacao
      ..isDeleted = isDeleted
      ..createdAt = createdAt
      ..updatedAt = updatedAt
      ..syncStatus = syncStatus
      ..createdBy = createdBy
      ..updatedBy = updatedBy;
  }
}
