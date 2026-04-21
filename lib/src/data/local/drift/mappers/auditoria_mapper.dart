import 'package:drift/drift.dart';
import '../app_database.dart';
import '../../../../domain/entities/auditoria.dart';

extension AuditoriaMapper on Auditoria {
  AuditoriasCompanion toCompanion() {
    return AuditoriasCompanion.insert(
      id: id,
      entidade: entidade,
      entidadeId: entidadeId,
      acao: acao,
      valorAnteriorJson: Value(valorAnteriorJson),
      valorNovoJson: Value(valorNovoJson),
      utilizadorId: utilizadorId,
      dataHora: dataHora,
    );
  }
}

extension AuditoriaDataMapper on AuditoriaData {
  Auditoria toEntity() {
    return Auditoria()
      ..localId = localId
      ..id = id
      ..entidade = entidade
      ..entidadeId = entidadeId
      ..acao = acao
      ..valorAnteriorJson = valorAnteriorJson
      ..valorNovoJson = valorNovoJson
      ..utilizadorId = utilizadorId
      ..dataHora = dataHora;
  }
}
