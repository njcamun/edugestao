import 'package:drift/drift.dart';
import '../app_database.dart';
import '../../../../domain/entities/pagamento.dart';

extension PagamentoMapper on Pagamento {
  PagamentosCompanion toCompanion() {
    return PagamentosCompanion.insert(
      id: id,
      mensalidadeId: mensalidadeId,
      valorPago: valorPago,
      dataPagamento: dataPagamento,
      formaPagamento: formaPagamento,
      observacao: Value(observacao),
      evidenciaId: Value(evidenciaId),
      numeroRecibo: numeroRecibo,
      confirmadoPor: confirmadoPor,
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncStatus: syncStatus,
      createdBy: Value(createdBy),
      updatedBy: Value(updatedBy),
      isDeleted: Value(isDeleted),
    );
  }
}

extension PagamentoDataMapper on PagamentoData {
  Pagamento toEntity() {
    return Pagamento()
      ..localId = localId
      ..id = id
      ..mensalidadeId = mensalidadeId
      ..valorPago = valorPago
      ..dataPagamento = dataPagamento
      ..formaPagamento = formaPagamento
      ..observacao = observacao
      ..evidenciaId = evidenciaId
      ..numeroRecibo = numeroRecibo
      ..confirmadoPor = confirmadoPor
      ..isDeleted = isDeleted
      ..createdAt = createdAt
      ..updatedAt = updatedAt
      ..syncStatus = syncStatus
      ..createdBy = createdBy
      ..updatedBy = updatedBy;
  }
}
