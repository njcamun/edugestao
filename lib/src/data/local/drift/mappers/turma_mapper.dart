import 'package:drift/drift.dart';
import '../app_database.dart';
import '../../../../domain/entities/turma.dart';

extension TurmaMapper on Turma {
  TurmasCompanion toCompanion() {
    return TurmasCompanion.insert(
      id: id,
      nomeTurma: nomeTurma,
      limiteAlunos: limiteAlunos,
      turno: turno,
      numeroSala: numeroSala,
      ativa: ativa,
      anoLectivoId: anoLectivoId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncStatus: syncStatus,
      createdBy: Value(createdBy),
      updatedBy: Value(updatedBy),
      isDeleted: Value(isDeleted),
    );
  }
}

extension TurmaDataMapper on TurmaData {
  Turma toEntity() {
    return Turma()
      ..localId = localId
      ..id = id
      ..nomeTurma = nomeTurma
      ..limiteAlunos = limiteAlunos
      ..turno = turno
      ..numeroSala = numeroSala
      ..ativa = ativa
      ..anoLectivoId = anoLectivoId
      ..isDeleted = isDeleted
      ..createdAt = createdAt
      ..updatedAt = updatedAt
      ..syncStatus = syncStatus
      ..createdBy = createdBy
      ..updatedBy = updatedBy;
  }
}
