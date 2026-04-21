import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/providers/database_provider.dart';
import '../../state/session.dart';
import '../../data/local/drift/app_database.dart';

class AuditService {
  final Ref _ref;

  AuditService(this._ref);

  Future<void> log({
    required String entidade,
    required String entidadeId,
    required String acao,
    Map<String, dynamic>? anterior,
    Map<String, dynamic>? novo,
  }) async {
    final session = _ref.read(sessionProvider);
    final db = _ref.read(databaseProvider);

    final auditoria = AuditoriasCompanion.insert(
      id: const Uuid().v4(),
      entidade: entidade,
      entidadeId: entidadeId,
      acao: acao,
      valorAnteriorJson: Value(anterior != null ? jsonEncode(anterior) : null),
      valorNovoJson: Value(novo != null ? jsonEncode(novo) : null),
      utilizadorId: session.firebaseUser?.uid ?? 'sistema',
      dataHora: DateTime.now(),
    );

    await db.into(db.auditorias).insert(auditoria);
  }
}

final auditServiceProvider = Provider((ref) => AuditService(ref));
