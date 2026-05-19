import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_tokens.dart';
import '../../shared/widgets/edu_card.dart';
import 'finance_summary_provider.dart';

class FinanceSummaryPage extends ConsumerWidget {
  const FinanceSummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(financeMonthSummaryProvider);
    final filter = ref.watch(financeMonthFilterProvider);
    final currency = NumberFormat.currency(locale: 'pt_AO', symbol: 'KZ');

    return summaryAsync.when(
      data: (s) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Caixa — ${filter.mes.toString().padLeft(2, '0')}/${filter.ano}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_left_rounded),
                  onPressed: () => _shiftMonth(ref, -1),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right_rounded),
                  onPressed: () => _shiftMonth(ref, 1),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: MediaQuery.sizeOf(context).width > 700 ? 2 : 1,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.4,
              children: [
                _KpiCard(
                  label: 'Receitas pagas',
                  value: currency.format(s.receitasPagas),
                  color: AppTokens.success,
                  icon: Icons.trending_up_rounded,
                ),
                _KpiCard(
                  label: 'Despesas pagas',
                  value: currency.format(s.despesasPagas),
                  color: AppTokens.warning,
                  icon: Icons.trending_down_rounded,
                ),
                _KpiCard(
                  label: 'Saldo do mês',
                  value: currency.format(s.saldo),
                  color: s.saldo >= 0 ? AppTokens.primary : AppTokens.error,
                  icon: Icons.account_balance_wallet_rounded,
                ),
                _KpiCard(
                  label: 'Pendente (receitas)',
                  value: currency.format(s.receitasPendentes),
                  color: AppTokens.info,
                  icon: Icons.schedule_rounded,
                ),
              ],
            ),
            const SizedBox(height: 20),
            EduCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Despesas por categoria', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 12),
                  if (s.despesasPorCategoria.isEmpty)
                    Text('Sem despesas neste mês.', style: Theme.of(context).textTheme.bodySmall)
                  else
                    ...s.despesasPorCategoria.entries.map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(child: Text(e.key)),
                            Text(currency.format(e.value), style: const TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            EduCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Previsão receitas', style: Theme.of(context).textTheme.bodySmall),
                      Text(currency.format(s.receitasTotal), style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Previsão despesas', style: Theme.of(context).textTheme.bodySmall),
                      Text(currency.format(s.despesasTotal), style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Erro: $e')),
    );
  }

  void _shiftMonth(WidgetRef ref, int delta) {
    final f = ref.read(financeMonthFilterProvider);
    var mes = f.mes + delta;
    var ano = f.ano;
    if (mes < 1) {
      mes = 12;
      ano--;
    } else if (mes > 12) {
      mes = 1;
      ano++;
    }
    ref.read(financeMonthFilterProvider.notifier).state = (mes: mes, ano: ano);
    ref.invalidate(financeMonthSummaryProvider);
  }
}

class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _KpiCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return EduCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodySmall),
                Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
