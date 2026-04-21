import 'package:drift/drift.dart';
import 'package:edugestao/src/data/local/drift/app_database.dart';
import 'package:edugestao/src/domain/entities/matricula.dart';
import 'package:edugestao/src/domain/entities/sync_entity.dart';

extension MatriculaMapper on Matricula {
  MatriculasCompanion toCompanion() {
    return MatriculasCompanion.insert(
      id: id,
      numeroMatricula: numeroMatricula,
      alunoId: alunoId,
      turmaId: turmaId,
      turno: turno,
      anoLectivo: anoLectivo,
      dataMatricula: dataMatricula,
      estado: estado,
      valorMensalidade: valorMensalidade,
      diaVencimento: diaVencimento,
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncStatus: syncStatus,
      createdBy: Value(createdBy),
      updatedBy: Value(updatedBy),
      isDeleted: Value(isDeleted),
    );
  }
}

extension MatriculaDataMapper on MatriculaData {
  Matricula toEntity() {
    return Matricula()
      ..localId = localId
      ..id = id
      ..numeroMatricula = numeroMatricula
      ..alunoId = alunoId
      ..turmaId = turmaId
      ..turno = turno
      ..anoLectivo = anoLectivo
      ..dataMatricula = dataMatricula
      ..estado = estado
      ..valorMensalidade = valorMensalidade
      ..diaVencimento = diaVencimento
      ..isDeleted = isDeleted
      ..createdAt = createdAt
      ..updatedAt = updatedAt
      ..syncStatus = syncStatus
      ..createdBy = createdBy
      ..updatedBy = updatedBy;
  }
}
