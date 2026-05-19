import 'package:drift/drift.dart';
import 'package:edugestao/src/data/local/drift/app_database.dart';
import 'package:edugestao/src/domain/entities/ativo_inventario.dart';

extension AtivoInventarioMapper on AtivoInventario {
  AtivosInventarioCompanion toCompanion() {
    return AtivosInventarioCompanion.insert(
      id: id,
      codigo: codigo,
      nome: nome,
      categoria: categoria,
      localizacao: localizacao,
      estado: estado,
      valorAquisicao: valorAquisicao,
      dataAquisicao: dataAquisicao,
      ultimaManutencao: Value(ultimaManutencao),
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

extension AtivoInventarioDataMapper on AtivoInventarioData {
  AtivoInventario toEntity() {
    return AtivoInventario()
      ..localId = localId
      ..id = id
      ..codigo = codigo
      ..nome = nome
      ..categoria = categoria
      ..localizacao = localizacao
      ..estado = estado
      ..valorAquisicao = valorAquisicao
      ..dataAquisicao = dataAquisicao
      ..ultimaManutencao = ultimaManutencao
      ..observacoes = observacoes
      ..isDeleted = isDeleted
      ..createdAt = createdAt
      ..updatedAt = updatedAt
      ..syncStatus = syncStatus
      ..createdBy = createdBy
      ..updatedBy = updatedBy;
  }
}

extension ManutencaoAtivoDataMapper on ManutencaoAtivoData {
  ManutencaoAtivo toEntity() {
    return ManutencaoAtivo()
      ..localId = localId
      ..id = id
      ..ativoId = ativoId
      ..data = data
      ..descricao = descricao
      ..custo = custo
      ..realizadoPor = realizadoPor;
  }
}
