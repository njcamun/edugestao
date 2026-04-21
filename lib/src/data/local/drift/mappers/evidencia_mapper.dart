import 'package:drift/drift.dart';
import '../app_database.dart';
import '../../../../domain/entities/evidencia_pagamento.dart';

extension EvidenciaMapper on EvidenciaPagamento {
  EvidenciaPagamentosCompanion toCompanion() {
    return EvidenciaPagamentosCompanion.insert(
      id: id,
      tipoArquivo: tipoArquivo,
      nomeArquivo: nomeArquivo,
      urlRemota: Value(urlRemota),
      caminhoLocal: caminhoLocal,
      tamanhoBytes: tamanhoBytes,
      mimeType: mimeType,
      createdAt: createdAt,
      syncStatus: syncStatus,
    );
  }
}

extension EvidenciaDataMapper on EvidenciaPagamentoData {
  EvidenciaPagamento toEntity() {
    return EvidenciaPagamento()
      ..localId = localId
      ..id = id
      ..tipoArquivo = tipoArquivo
      ..nomeArquivo = nomeArquivo
      ..urlRemota = urlRemota
      ..caminhoLocal = caminhoLocal
      ..tamanhoBytes = tamanhoBytes
      ..mimeType = mimeType
      ..createdAt = createdAt
      ..syncStatus = syncStatus;
  }
}
