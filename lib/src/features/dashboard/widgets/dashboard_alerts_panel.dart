import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/edu_card.dart';
import '../../salaries/salaries_controller.dart';

final pendingTuitionProvider = FutureProvider<List<({String alunoId, String nome, double valor})>>((ref) async {
  final db = ref.watch(databaseProvider);
  final mensalidades = await (db.select(db.mensalidades)
        ..where((t) => t.isDeleted.equals(false) & t.estado.equals('pendente')))
      .get();

  final results = <({String alunoId, String nome, double valor})>[];
  for (final m in mensalidades.take(5)) {
    final aluno = await (db.select(db.alunos)..where((t) => t.id.equals(m.alunoId))).getSingleOrNull();
    final nome = aluno?.nomeCompleto ?? 'Aluno';
    results.add((alunoId: m.alunoId, nome: nome, valor: m.valor));
  }
  return results;
});

class DashboardAlertsPanel extends ConsumerWidget {
  const DashboardAlertsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tuitionAsync = ref.watch(pendingTuitionProvider);
    final salariosPendentes = ref.watch(pendingSalariesCountProvider);
    final currency = NumberFormat.currency(locale: 'pt_AO', symbol: 'KZ');

    final tuitionCard = _buildTuitionCard(context, tuitionAsync, currency);
    final noticesCard = _buildNoticesCard(context, salariosPendentes);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: tuitionCard),
              const SizedBox(width: 16),
              Expanded(child: noticesCard),
            ],
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            tuitionCard,
            const SizedBox(height: 16),
            noticesCard,
          ],
        );
      },
    );
  }

  Widget _buildTuitionCard(
    BuildContext context,
    AsyncValue<List<({String alunoId, String nome, double valor})>> tuitionAsync,
    NumberFormat currency,
  ) {
    return EduCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: AppTokens.warning, size: 20),
              const SizedBox(width: 8),
              Text('Propinas pendentes', style: Theme.of(context).textTheme.titleSmall),
            ],
          ),
          const SizedBox(height: 12),
          tuitionAsync.when(
            data: (list) {
              if (list.isEmpty) {
                return Text('Nenhuma propina pendente.', style: Theme.of(context).textTheme.bodySmall);
              }
              return Column(
                children: list
                    .map(
                      (item) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: Text(item.nome, style: const TextStyle(fontSize: 13)),
                        trailing: Text(currency.format(item.valor),
                            style: const TextStyle(fontWeight: FontWeight.w600, color: AppTokens.error)),
                        onTap: () => context.go('/financeiro'),
                      ),
                    )
                    .toList(),
              );
            },
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const Text('Erro ao carregar'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoticesCard(BuildContext context, int salariosPendentes) {
    return EduCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.notifications_outlined, color: AppTokens.primary, size: 20),
              const SizedBox(width: 8),
              Text('Avisos importantes', style: Theme.of(context).textTheme.titleSmall),
            ],
          ),
          const SizedBox(height: 12),
          _NoticeRow(
            icon: Icons.payments_outlined,
            color: AppTokens.warning,
            text: '$salariosPendentes salário(s) pendente(s) este mês',
            onTap: () => context.go('/salarios'),
          ),
          const SizedBox(height: 8),
          _NoticeRow(
            icon: Icons.school_outlined,
            color: AppTokens.primary,
            text: 'Ver secretaria académica',
            onTap: () => context.go('/alunos'),
          ),
        ],
      ),
    );
  }
}

class _NoticeRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  final VoidCallback onTap;

  const _NoticeRow({
    required this.icon,
    required this.color,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 10),
            Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
            const Icon(Icons.chevron_right_rounded, size: 18, color: AppTokens.textMuted),
          ],
        ),
      ),
    );
  }
}
