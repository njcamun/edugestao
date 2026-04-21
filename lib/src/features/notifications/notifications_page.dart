import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/providers/database_provider.dart';
import '../../core/theme/app_tokens.dart';
import '../../data/local/drift/app_database.dart';
import '../../data/local/drift/mappers/notificacao_mapper.dart';
import '../../domain/entities/notificacao.dart';

final notificationsStreamProvider = StreamProvider<List<NotificacaoInterna>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.notificacoesInternas)
        ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]))
      .watch()
      .map((rows) => rows.map((row) => row.toEntity()).toList());
});

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsStreamProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Centro de Notificações', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          Expanded(
            child: notificationsAsync.when(
              data: (notificacoes) {
                if (notificacoes.isEmpty) return const Center(child: Text('Nenhuma notificação.'));
                return ListView.builder(
                  itemCount: notificacoes.length,
                  itemBuilder: (context, index) {
                    final n = notificacoes[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppTokens.border)),
                      elevation: 0,
                      child: ListTile(
                        leading: Icon(_getIcon(n.tipo), color: _getColor(n.tipo)),
                        title: Text(n.titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${n.mensagem}\n${DateFormat('dd/MM HH:mm').format(n.createdAt)}'),
                        isThreeLine: true,
                        trailing: n.lida ? null : const CircleAvatar(radius: 4, backgroundColor: AppTokens.accent),
                        onTap: () async {
                          final db = ref.read(databaseProvider);
                          final updateQuery = db.update(db.notificacoesInternas)..where((t) => t.id.equals(n.id));
                          await updateQuery.write(
                            const NotificacoesInternasCompanion(
                              lida: Value(true),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Erro: $e')),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String tipo) {
    switch (tipo) {
      case 'success': return Icons.check_circle_outline;
      case 'error': return Icons.error_outline;
      case 'warning': return Icons.warning_amber_rounded;
      default: return Icons.info_outline;
    }
  }

  Color _getColor(String tipo) {
    switch (tipo) {
      case 'success': return AppTokens.success;
      case 'error': return AppTokens.error;
      case 'warning': return Colors.orange;
      default: return AppTokens.slate400;
    }
  }
}
