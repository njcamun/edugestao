import 'package:drift/drift.dart';
import 'package:edugestao/src/data/local/drift/app_database.dart';
import 'package:edugestao/src/domain/entities/funcionario.dart';

extension FuncionarioMapper on Funcionario {
  FuncionariosCompanion toCompanion() {
    return FuncionariosCompanion.insert(
      id: id,
      numeroFuncionario: numeroFuncionario,
      nomeCompleto: nomeCompleto,
      cargo: cargo,
      email: Value(email),
      telefone: telefone,
      documentoIdentidade: Value(documentoIdentidade),
      dataAdmissao: dataAdmissao,
      salarioBase: salarioBase,
      status: status,
      ultimaPresenca: Value(ultimaPresenca),
      observacoes: Value(observacoes),
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncStatus: syncStatus,
      createdBy: Value(createdBy),
      updatedBy: Value(updatedBy),
      isDeleted: Value(isDeleted),
    );
  }
}

extension FuncionarioDataMapper on FuncionarioData {
  Funcionario toEntity() {
    return Funcionario()
      ..localId = localId
      ..id = id
      ..numeroFuncionario = numeroFuncionario
      ..nomeCompleto = nomeCompleto
      ..cargo = cargo
      ..email = email
      ..telefone = telefone
      ..documentoIdentidade = documentoIdentidade
      ..dataAdmissao = dataAdmissao
      ..salarioBase = salarioBase
      ..status = status
      ..ultimaPresenca = ultimaPresenca
      ..observacoes = observacoes
      ..isDeleted = isDeleted
      ..createdAt = createdAt
      ..updatedAt = updatedAt
      ..syncStatus = syncStatus
      ..createdBy = createdBy
      ..updatedBy = updatedBy;
  }
}
