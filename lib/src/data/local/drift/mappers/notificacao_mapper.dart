import 'package:drift/drift.dart';
import '../app_database.dart';
import '../../../../domain/entities/notificacao.dart';

extension NotificacaoMapper on NotificacaoInterna {
  NotificacoesInternasCompanion toCompanion() {
    return NotificacoesInternasCompanion.insert(
      id: id,
      titulo: titulo,
      mensagem: mensagem,
      tipo: tipo,
      entidadeRelacionada: Value(entidadeRelacionada),
      entidadeId: Value(entidadeId),
      lida: Value(lida),
      createdAt: createdAt,
    );
  }
}

extension NotificacaoDataMapper on NotificacoesInternaData {
  NotificacaoInterna toEntity() {
    return NotificacaoInterna()
      ..localId = localId
      ..id = id
      ..titulo = titulo
      ..mensagem = mensagem
      ..tipo = tipo
      ..entidadeRelacionada = entidadeRelacionada
      ..entidadeId = entidadeId
      ..lida = lida
      ..createdAt = createdAt;
  }
}
