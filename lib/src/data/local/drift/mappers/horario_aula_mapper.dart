import 'package:drift/drift.dart';
import 'package:edugestao/src/data/local/drift/app_database.dart';
import 'package:edugestao/src/domain/entities/horario_aula.dart';

extension HorarioAulaMapper on HorarioAula {
  HorariosAulaCompanion toCompanion() {
    return HorariosAulaCompanion.insert(
      id: id,
      turmaId: turmaId,
      diaSemana: diaSemana,
      horaInicio: horaInicio,
      horaFim: horaFim,
      disciplina: disciplina,
      professor: Value(professor),
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncStatus: syncStatus,
      createdBy: Value(createdBy),
      updatedBy: Value(updatedBy),
      isDeleted: Value(isDeleted),
    );
  }
}

extension HorarioAulaDataMapper on HorarioAulaData {
  HorarioAula toEntity() {
    return HorarioAula()
      ..localId = localId
      ..id = id
      ..turmaId = turmaId
      ..diaSemana = diaSemana
      ..horaInicio = horaInicio
      ..horaFim = horaFim
      ..disciplina = disciplina
      ..professor = professor
      ..isDeleted = isDeleted
      ..createdAt = createdAt
      ..updatedAt = updatedAt
      ..syncStatus = syncStatus
      ..createdBy = createdBy
      ..updatedBy = updatedBy;
  }
}
