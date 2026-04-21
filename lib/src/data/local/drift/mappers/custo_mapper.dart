import 'package:drift/drift.dart';
import 'package:edugestao/src/data/local/drift/app_database.dart';
import 'package:edugestao/src/domain/entities/custo.dart';
import 'package:edugestao/src/domain/entities/sync_entity.dart';

extension CustoMensalMapper on CustoMensal {
  CustosMensaisCompanion toCompanion() {
    return CustosMensaisCompanion.insert(
      id: id,
      descricao: descricao,
      categoria: categoria,
      valor: valor,
      data: data,
      tipo: tipo,
      mesReferencia: mesReferencia,
      anoReferencia: anoReferencia,
      estado: estado,
      observacao: Value(observacao),
      comprovativoUrl: Value(comprovativoUrl),
      comprovativoLocal: Value(comprovativoLocal),
      responsavelId: responsavelId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncStatus: syncStatus,
      createdBy: Value(createdBy),
      updatedBy: Value(updatedBy),
      isDeleted: Value(isDeleted),
    );
  }
}

extension CustoMensalDataMapper on CustoMensalData {
  CustoMensal toEntity() {
    return CustoMensal()
      ..localId = localId
      ..id = id
      ..descricao = descricao
      ..categoria = categoria
      ..valor = valor
      ..data = data
      ..tipo = tipo
      ..mesReferencia = mesReferencia
      ..anoReferencia = anoReferencia
      ..estado = estado
      ..observacao = observacao
      ..comprovativoUrl = comprovativoUrl
      ..comprovativoLocal = comprovativoLocal
      ..responsavelId = responsavelId
      ..isDeleted = isDeleted
      ..createdAt = createdAt
      ..updatedAt = updatedAt
      ..syncStatus = syncStatus
      ..createdBy = createdBy
      ..updatedBy = updatedBy;
  }
}
