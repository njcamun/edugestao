import 'package:drift/drift.dart';
import 'package:edugestao/src/data/local/drift/app_database.dart';
import 'package:edugestao/src/domain/entities/ano_lectivo.dart';
import 'package:edugestao/src/domain/entities/sync_entity.dart';

extension AnoLectivoMapper on AnoLectivo {
  AnosLectivosCompanion toCompanion() {
    return AnosLectivosCompanion.insert(
      id: id,
      ano: ano,
      dataInicio: dataInicio,
      dataFim: dataFim,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncStatus: syncStatus,
      createdBy: Value(createdBy),
      updatedBy: Value(updatedBy),
      isDeleted: Value(isDeleted),
    );
  }
}

extension AnoLectivoDataMapper on AnosLectivoData {
  AnoLectivo toEntity() {
    return AnoLectivo()
      ..localId = localId
      ..id = id
      ..ano = ano
      ..dataInicio = dataInicio
      ..dataFim = dataFim
      ..isActive = isActive
      ..isDeleted = isDeleted
      ..createdAt = createdAt
      ..updatedAt = updatedAt
      ..syncStatus = syncStatus
      ..createdBy = createdBy
      ..updatedBy = updatedBy;
  }
}
