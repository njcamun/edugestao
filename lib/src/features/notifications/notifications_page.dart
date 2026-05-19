import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/providers/database_provider.dart';
import '../../data/sync/sync_service.dart';
import '../../core/theme/app_tokens.dart';
import '../../data/local/drift/app_database.dart';
import '../../data/local/drift/mappers/notificacao_mapper.dart';
import '../../domain/entities/notificacao.dart';
import '../../shared/widgets/edu_card.dart';
import '../../shared/widgets/edu_empty_state.dart';
import 'widgets/notification_form_dialog.dart';

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
    final naoLidas = notificationsAsync.valueOrNull?.where((n) => !n.lida).length ?? 0;

    Future<void> marcarTodasLidas() async {
      final db = ref.read(databaseProvider);
      await db.update(db.notificacoesInternas).write(const NotificacoesInternasCompanion(lida: Value(true)));
      ref.read(syncServiceProvider).syncLocalToCloud();
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(context: context, builder: (_) => const NotificationFormDialog()),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Novo aviso'),
        backgroundColor: AppTokens.primary,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (naoLidas > 0)
            _UnreadBanner(count: naoLidas, onMarkAllRead: marcarTodasLidas),
          Expanded(
            child: notificationsAsync.when(
              data: (notificacoes) {
                if (notificacoes.isEmpty) {
                  return const EduEmptyState(
                    icon: Icons.notifications_none_outlined,
                    title: 'Sem notificações',
                    message: 'Os avisos do sistema (matrículas, pagamentos, sync) aparecem aqui.',
                  );
                }
                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: notificacoes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppTokens.paddingSM),
                  itemBuilder: (context, index) {
                    final n = notificacoes[index];
                    return _NotificationCard(notificacao: n);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: AppTokens.primary)),
              error: (e, _) => EduEmptyState(
                icon: Icons.error_outline_rounded,
                title: 'Erro ao carregar',
                message: e.toString(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UnreadBanner extends StatelessWidget {
  final int count;
  final VoidCallback onMarkAllRead;

  const _UnreadBanner({required this.count, required this.onMarkAllRead});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTokens.paddingMD),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTokens.info.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTokens.radiusMD),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$count notificação(ões) por ler',
              style: const TextStyle(fontWeight: FontWeight.w600, color: AppTokens.info),
            ),
          ),
          TextButton(onPressed: onMarkAllRead, child: const Text('Marcar todas')),
        ],
      ),
    );
  }
}

class _NotificationCard extends ConsumerWidget {
  final NotificacaoInterna notificacao;
  const _NotificationCard({required this.notificacao});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = _colorFor(notificacao.tipo);
    final icon = _iconFor(notificacao.tipo);

    return EduCard(
      color: notificacao.lida ? null : AppTokens.primary.withValues(alpha: 0.04),
      onTap: () async {
        if (notificacao.lida) return;
        final db = ref.read(databaseProvider);
        await (db.update(db.notificacoesInternas)..where((t) => t.id.equals(notificacao.id))).write(
          const NotificacoesInternasCompanion(lida: Value(true)),
        );
        ref.read(syncServiceProvider).syncLocalToCloud();
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppTokens.radiusMD),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: AppTokens.paddingMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notificacao.titulo,
                        style: TextStyle(
                          fontWeight: notificacao.lida ? FontWeight.w500 : FontWeight.w600,
                          color: AppTokens.textPrimary,
                        ),
                      ),
                    ),
                    if (!notificacao.lida)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(color: AppTokens.primary, shape: BoxShape.circle),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(notificacao.mensagem, style: const TextStyle(color: AppTokens.textSecondary, fontSize: 13)),
                const SizedBox(height: 6),
                Text(
                  DateFormat('dd/MM/yyyy HH:mm').format(notificacao.createdAt),
                  style: const TextStyle(fontSize: 11, color: AppTokens.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(String tipo) => switch (tipo) {
        'success' => Icons.check_circle_outline_rounded,
        'error' => Icons.error_outline_rounded,
        'warning' => Icons.warning_amber_rounded,
        _ => Icons.info_outline_rounded,
      };

  Color _colorFor(String tipo) => switch (tipo) {
        'success' => AppTokens.success,
        'error' => AppTokens.error,
        'warning' => AppTokens.warning,
        _ => AppTokens.info,
      };
}
