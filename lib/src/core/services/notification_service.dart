import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/providers/database_provider.dart';
import '../../data/local/drift/app_database.dart';

class NotificationService {
  final Ref _ref;

  NotificationService(this._ref);

  Future<void> notify({
    required String titulo,
    required String mensagem,
    required String tipo,
    String? entidadeRelacionada,
    String? entidadeId,
  }) async {
    final db = _ref.read(databaseProvider);

    final notificacao = NotificacoesInternasCompanion.insert(
      id: const Uuid().v4(),
      titulo: titulo,
      mensagem: mensagem,
      tipo: tipo,
      entidadeRelacionada: Value(entidadeRelacionada),
      entidadeId: Value(entidadeId),
      lida: const Value(false),
      createdAt: DateTime.now(),
    );

    await db.into(db.notificacoesInternas).insert(notificacao);
  }
}

final notificationServiceProvider = Provider((ref) => NotificationService(ref));
