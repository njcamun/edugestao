import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_tokens.dart';
import '../../domain/entities/salario.dart';
import '../../shared/widgets/edu_card.dart';
import '../../shared/widgets/edu_empty_state.dart';
import '../../state/session.dart';
import 'salaries_controller.dart';
import 'widgets/salary_form_dialog.dart';

class SalariesPage extends ConsumerWidget {
  const SalariesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salariesAsync = ref.watch(salariesStreamProvider);
    final filter = ref.watch(salaryFilterProvider);
    final canEdit = ref.watch(sessionProvider).perfil?.canViewFinance ?? false;
    final currency = NumberFormat.currency(locale: 'pt_AO', symbol: 'KZ');

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Folha ${filter.mes.toString().padLeft(2, '0')}/${filter.ano}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                tooltip: 'Mês anterior',
                onPressed: () => _shiftMonth(ref, -1),
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              IconButton(
                tooltip: 'Mês seguinte',
                onPressed: () => _shiftMonth(ref, 1),
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: salariesAsync.when(
              data: (list) {
                if (list.isEmpty) {
                  return EduEmptyState(
                    icon: Icons.payments_outlined,
                    title: 'Sem salários neste mês',
                    message: canEdit
                        ? 'Gere a folha automática ou registe um processamento manual.'
                        : null,
                    actionLabel: canEdit ? 'Gerar folha' : null,
                    onAction: canEdit ? () => gerarFolhaMensal(ref) : null,
                  );
                }

                final pendentes = list.where((s) => s.estado == SalarioEstado.pendente).length;
                final totalPago = list
                    .where((s) => s.estado == SalarioEstado.pago)
                    .fold<double>(0, (a, s) => a + s.valorLiquido);

                return Column(
                  children: [
                    EduCard(
                      child: Row(
                        children: [
                          _SummaryTile(
                            label: 'Pendentes',
                            value: '$pendentes',
                            color: AppTokens.warning,
                          ),
                          _SummaryTile(
                            label: 'Total pago',
                            value: currency.format(totalPago),
                            color: AppTokens.success,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.separated(
                        itemCount: list.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, i) {
                          final s = list[i];
                          return EduCard(
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(s.funcionarioNome),
                              subtitle: Text(
                                'Base ${currency.format(s.valorBase)} · Líquido ${currency.format(s.valorLiquido)}',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _EstadoChip(estado: s.estado),
                                  if (canEdit && s.estado == SalarioEstado.pendente) ...[
                                    const SizedBox(width: 8),
                                    IconButton(
                                      tooltip: 'Marcar como pago',
                                      icon: const Icon(Icons.check_circle_outline_rounded),
                                      color: AppTokens.success,
                                      onPressed: () =>
                                          ref.read(salaryActionsProvider).marcarPago(s.id),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Erro: $e')),
            ),
          ),
          if (canEdit) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              children: [
                OutlinedButton.icon(
                  onPressed: () => gerarFolhaMensal(ref),
                  icon: const Icon(Icons.auto_fix_high_rounded),
                  label: const Text('Gerar folha'),
                ),
                FilledButton.icon(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => const SalaryFormDialog(),
                  ),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Processar salário'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _shiftMonth(WidgetRef ref, int delta) {
    final f = ref.read(salaryFilterProvider);
    var mes = f.mes + delta;
    var ano = f.ano;
    if (mes < 1) {
      mes = 12;
      ano--;
    } else if (mes > 12) {
      mes = 1;
      ano++;
    }
    ref.read(salaryFilterProvider.notifier).state = (mes: mes, ano: ano);
  }
}

class _SummaryTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryTile({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          Text(value, style: TextStyle(fontWeight: FontWeight.w700, color: color, fontSize: 18)),
        ],
      ),
    );
  }
}

class _EstadoChip extends StatelessWidget {
  final SalarioEstado estado;
  const _EstadoChip({required this.estado});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (estado) {
      SalarioEstado.pendente => ('Pendente', AppTokens.warning),
      SalarioEstado.pago => ('Pago', AppTokens.success),
      SalarioEstado.cancelado => ('Cancelado', AppTokens.error),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
    );
  }
}
