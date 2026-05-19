import 'package:drift/drift.dart';
import 'package:edugestao/src/data/local/drift/app_database.dart';
import 'package:edugestao/src/domain/entities/nota_avaliacao.dart';

extension NotaAvaliacaoMapper on NotaAvaliacao {
  NotasAvaliacaoCompanion toCompanion() {
    return NotasAvaliacaoCompanion.insert(
      id: id,
      alunoId: alunoId,
      disciplina: disciplina,
      trimestre: trimestre,
      anoLectivo: anoLectivo,
      valor: valor,
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

extension NotaAvaliacaoDataMapper on NotaAvaliacaoData {
  NotaAvaliacao toEntity() {
    return NotaAvaliacao()
      ..localId = localId
      ..id = id
      ..alunoId = alunoId
      ..disciplina = disciplina
      ..trimestre = trimestre
      ..anoLectivo = anoLectivo
      ..valor = valor
      ..observacao = observacao
      ..isDeleted = isDeleted
      ..createdAt = createdAt
      ..updatedAt = updatedAt
      ..syncStatus = syncStatus
      ..createdBy = createdBy
      ..updatedBy = updatedBy;
  }
}
