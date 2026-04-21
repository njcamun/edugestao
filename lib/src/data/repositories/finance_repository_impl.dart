import 'package:drift/drift.dart';
import '../../domain/entities/mensalidade.dart';
import '../../domain/entities/pagamento.dart';
import '../../domain/entities/evidencia_pagamento.dart';
import '../../domain/entities/sync_entity.dart';
import '../../domain/repositories/finance_repository.dart';
import '../local/drift/app_database.dart';
import '../local/drift/mappers/mensalidade_mapper.dart';
import '../local/drift/mappers/pagamento_mapper.dart';
import '../local/drift/mappers/evidencia_mapper.dart';
import '../../core/services/audit_service.dart';
import '../../core/services/notification_service.dart';

import '../sync/sync_service.dart';

class FinanceRepositoryImpl implements FinanceRepository {
  final AppDatabase _db;
  final AuditService _audit;
  final NotificationService _notification;
  final SyncService _sync;

  FinanceRepositoryImpl(this._db, this._audit, this._notification, this._sync);

  @override
  Stream<List<Mensalidade>> watchMensalidades({String? alunoId}) {
    final query = _db.select(_db.mensalidades);
    if (alunoId != null) {
      query.where((t) => t.alunoId.equals(alunoId));
    }
    query.orderBy([(t) => OrderingTerm(expression: t.dataVencimento)]);

    return query.watch().map((rows) => rows.map((row) => row.toEntity()).toList());
  }

  @override
  Future<void> saveMensalidade(Mensalidade mensalidade) async {
    final query = _db.select(_db.mensalidades)..where((t) => t.id.equals(mensalidade.id));
    final rows = await query.get();
    final companion = rows.isNotEmpty
      ? mensalidade.toCompanion().copyWith(localId: Value(rows.first.localId))
      : mensalidade.toCompanion();

    await _db.into(_db.mensalidades).insertOnConflictUpdate(companion);
    _sync.syncLocalToCloud();
  }

  @override
  Future<void> saveMultipleMensalidades(List<Mensalidade> mensalidades) async {
    await _db.batch((batch) {
      for (final m in mensalidades) {
        batch.insert(_db.mensalidades, m.toCompanion(), mode: InsertMode.insertOrReplace);
      }
    });
    _sync.syncLocalToCloud();
  }

  @override
  Future<void> confirmarPagamento({
    required Pagamento pagamento,
    required EvidenciaPagamento evidencia,
    required String mensalidadeId,
  }) async {
    await _db.transaction(() async {
      // 1. Guardar Evidência
      await _db.into(_db.evidenciaPagamentos).insertOnConflictUpdate(evidencia.toCompanion());
      
      // 2. Guardar Pagamento
      pagamento.evidenciaId = evidencia.id;
      await _db.into(_db.pagamentos).insertOnConflictUpdate(pagamento.toCompanion());

      // 3. Atualizar Estado da Mensalidade
      final query = _db.update(_db.mensalidades)..where((t) => t.id.equals(mensalidadeId));
      await query.write(
        MensalidadesCompanion(
          estado: const Value('pago'),
          dataPagamento: Value(pagamento.dataPagamento),
          updatedAt: Value(DateTime.now()),
          syncStatus: const Value(SyncStatus.pendingSync),
        ),
      );
    });

    _sync.syncLocalToCloud();

    // 4. Auditoria
    await _audit.log(
      entidade: 'Pagamento',
      entidadeId: pagamento.id,
      acao: 'CONFIRM_PAYMENT',
      novo: {'valor': pagamento.valorPago, 'mensalidade': mensalidadeId},
    );

    // 5. Notificação Interna
    await _notification.notify(
      titulo: 'Pagamento Confirmado',
      mensagem: 'Recibo ${pagamento.numeroRecibo} gerado. Valor: ${pagamento.valorPago} KZ.',
      tipo: 'success',
      entidadeRelacionada: 'Pagamento',
      entidadeId: pagamento.id,
    );
  }

  @override
  Future<List<Pagamento>> getPagamentosByMensalidade(String mensalidadeId) async {
    final query = _db.select(_db.pagamentos)..where((t) => t.mensalidadeId.equals(mensalidadeId));
    final rows = await query.get();
    return rows.map((row) => row.toEntity()).toList();
  }

  @override
  Future<EvidenciaPagamento?> getEvidenciaById(String evidenciaId) async {
    final query = _db.select(_db.evidenciaPagamentos)..where((t) => t.id.equals(evidenciaId));
    final row = await query.getSingleOrNull();
    return row?.toEntity();
  }
}
