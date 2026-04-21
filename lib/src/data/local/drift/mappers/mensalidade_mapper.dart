import 'package:drift/drift.dart';
import '../app_database.dart';
import '../../../../domain/entities/mensalidade.dart';

extension MensalidadeMapper on Mensalidade {
  MensalidadesCompanion toCompanion() {
    return MensalidadesCompanion.insert(
      id: id,
      matriculaId: matriculaId,
      alunoId: alunoId,
      turmaId: turmaId,
      turno: turno,
      mesReferencia: mesReferencia,
      anoReferencia: anoReferencia,
      valor: valor,
      dataVencimento: dataVencimento,
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

extension MensalidadeDataMapper on MensalidadeData {
  Mensalidade toEntity() {
    return Mensalidade()
      ..localId = localId
      ..id = id
      ..matriculaId = matriculaId
      ..alunoId = alunoId
      ..turmaId = turmaId
      ..turno = turno
      ..mesReferencia = mesReferencia
      ..anoReferencia = anoReferencia
      ..valor = valor
      ..dataVencimento = dataVencimento
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
