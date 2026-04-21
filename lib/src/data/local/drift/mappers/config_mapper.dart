import 'package:drift/drift.dart';
import 'package:edugestao/src/data/local/drift/app_database.dart';
import 'package:edugestao/src/domain/entities/configuracao.dart';
import 'package:edugestao/src/domain/entities/sync_entity.dart';

extension ConfigMapper on ConfiguracaoInstitucional {
  ConfiguracoesCompanion toCompanion() {
    return ConfiguracoesCompanion.insert(
      id: id,
      nomeInstituicao: nomeInstituicao,
      logotipoUrl: Value(logotipoUrl),
      morada: morada,
      telefone: telefone,
      email: email,
      nif: nif,
      moedaPadrao: moedaPadrao,
      textoRodapeRelatorio: textoRodapeRelatorio,
      reciboPrefixo: reciboPrefixo,
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncStatus: syncStatus,
      createdBy: Value(createdBy),
      updatedBy: Value(updatedBy),
      isDeleted: Value(isDeleted),
    );
  }
}

extension ConfigDataMapper on ConfiguracaoData {
  ConfiguracaoInstitucional toEntity() {
    return ConfiguracaoInstitucional()
      ..localId = localId
      ..id = id
      ..nomeInstituicao = nomeInstituicao
      ..logotipoUrl = logotipoUrl
      ..morada = morada
      ..telefone = telefone
      ..email = email
      ..nif = nif
      ..moedaPadrao = moedaPadrao
      ..textoRodapeRelatorio = textoRodapeRelatorio
      ..reciboPrefixo = reciboPrefixo
      ..isDeleted = isDeleted
      ..createdAt = createdAt
      ..updatedAt = updatedAt
      ..syncStatus = syncStatus
      ..createdBy = createdBy
      ..updatedBy = updatedBy;
  }
}
