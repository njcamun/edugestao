import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/database_provider.dart';

final unreadNotificationsCountProvider = StreamProvider<int>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.notificacoesInternas)..where((t) => t.lida.equals(false)))
      .watch()
      .map((rows) => rows.length);
});
