import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_tokens.dart';
import '../../shared/firebase_service.dart';
import 'dashboard_chart_provider.dart';
import 'widgets/dashboard_alerts_panel.dart';
import 'widgets/dashboard_chart.dart';
import 'widgets/dashboard_stats_card.dart';
import '../../shared/widgets/edu_card.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebase = ref.watch(firebaseServiceProvider);
    final currencyFmt = NumberFormat.currency(locale: 'pt_AO', symbol: 'KZ');

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumo da escola',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTokens.primaryDark,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              'Indicadores e alertas do período actual.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTokens.textMuted,
                  ),
            ),
            const SizedBox(height: 20),
            _AcademicYearBanner(),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 900;
                final isCompact = constraints.maxWidth < 640;

                return Column(
                  children: [
                    FutureBuilder<Map<String, dynamic>>(
                      future: firebase.getOperationalStats(),
                      builder: (context, snapshot) {
                        final active = snapshot.data?['activeEnrollments'] ?? 0;
                        final total = snapshot.data?['totalStudents'] ?? 0;
                        final inactive = snapshot.data?['inactiveStudents'] ?? 0;
                        final avg = snapshot.data?['avgStudentsPerClass'] ?? 0.0;
                        final capacity = snapshot.data?['totalCapacity'] ?? 0;
                        final spots = snapshot.data?['availableSpots'] ?? 0;
                        final classes = snapshot.data?['totalClasses'] ?? 0;

                        return GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: isWide ? 2 : 1,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: isWide ? 2.2 : 1.85,
                          children: [
                            DashboardStatsCard(
                              title: 'Alunos matriculados',
                              value: '$active',
                              label1: 'Previsão',
                              value1: '$capacity',
                              label2: 'Inscritos',
                              value2: '$total',
                              label3: 'Não matric.',
                              value3: '$inactive',
                              subtitle: 'Alunos com matrícula activa',
                              icon: Icons.people_alt_rounded,
                              accentColor: AppTokens.primary,
                            ),
                            DashboardStatsCard(
                              title: 'Alunos por turma',
                              value: avg.toStringAsFixed(1),
                              label1: 'Turmas',
                              value1: '$classes',
                              label2: 'Máx. alunos',
                              value2: '$capacity',
                              label3: 'Vagas',
                              value3: '$spots',
                              subtitle: 'Média de ocupação por sala',
                              icon: Icons.school_rounded,
                              accentColor: AppTokens.accentPurple,
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    FutureBuilder<Map<String, dynamic>>(
                      future: firebase.getFinanceStats(),
                      builder: (context, snapshot) {
                        final revenue = snapshot.data?['monthlyRevenue'] ?? 0.0;
                        final revenuePaid = snapshot.data?['monthlyRevenuePaid'] ?? 0.0;
                        final revenuePending = snapshot.data?['monthlyRevenuePending'] ?? 0.0;
                        final costs = snapshot.data?['monthlyCosts'] ?? 0.0;
                        final costsPaid = snapshot.data?['monthlyCostsPaid'] ?? 0.0;
                        final costsPending = snapshot.data?['monthlyCostsPending'] ?? 0.0;
                        final balance = snapshot.data?['netBalance'] ?? 0.0;

                        return Column(
                          children: [
                            GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: isWide ? 2 : 1,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: isWide ? 2.2 : 1.85,
                              children: [
                                DashboardStatsCard(
                                  title: 'Receita mensal',
                                  value: currencyFmt.format(revenuePaid),
                                  label1: 'Previsão',
                                  value1: currencyFmt.format(revenue),
                                  label2: 'Pendente',
                                  value2: currencyFmt.format(revenuePending),
                                  subtitle: 'Valor já pago no mês actual',
                                  icon: Icons.trending_up_rounded,
                                  accentColor: AppTokens.success,
                                ),
                                DashboardStatsCard(
                                  title: 'Despesas mensais',
                                  value: currencyFmt.format(costsPaid),
                                  label1: 'Previsão',
                                  value1: currencyFmt.format(costs),
                                  label2: 'Pendente',
                                  value2: currencyFmt.format(costsPending),
                                  subtitle: 'Total pago no mês',
                                  icon: Icons.trending_down_rounded,
                                  accentColor: AppTokens.warning,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _BalanceCard(
                              balance: currencyFmt.format(balance),
                              isCompact: isCompact,
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    ref.watch(dashboardChartProvider).when(
                      data: (chart) => EduCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Receitas vs despesas (6 meses)',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 16),
                            DashboardChart(
                              receitas: chart.receitas,
                              despesas: chart.despesas,
                              labels: chart.labels,
                            ),
                          ],
                        ),
                      ),
                      loading: () => const EduCard(
                        child: SizedBox(
                          height: 120,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 24),
                    const DashboardAlertsPanel(),
                    const SizedBox(height: 32),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AcademicYearBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final year = DateTime.now().month >= 9 ? DateTime.now().year : DateTime.now().year - 1;
    final label = '$year / ${year + 1}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTokens.primary, AppTokens.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppTokens.radiusLG),
        boxShadow: AppTokens.elevatedShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppTokens.radiusMD),
            ),
            child: const Icon(Icons.calendar_today_rounded, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ano lectivo actual',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
                ),
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final String balance;
  final bool isCompact;

  const _BalanceCard({required this.balance, required this.isCompact});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isCompact ? 18 : 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTokens.primaryDark,
            AppTokens.primaryDark.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(AppTokens.radiusLG),
        boxShadow: AppTokens.elevatedShadow,
      ),
      child: isCompact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 28),
                const SizedBox(height: 12),
                Text('Saldo líquido do mês', style: _labelStyle(context)),
                const SizedBox(height: 4),
                Text(balance, style: _valueStyle(context)),
                const SizedBox(height: 4),
                Text('Após dedução de despesas', style: _hintStyle(context)),
              ],
            )
          : Row(
              children: [
                const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 40),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Saldo líquido do mês', style: _labelStyle(context)),
                      const SizedBox(height: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(balance, style: _valueStyle(context)),
                      ),
                      const SizedBox(height: 4),
                      Text('Valor disponível após dedução de despesas', style: _hintStyle(context)),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  TextStyle? _labelStyle(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70);

  TextStyle _valueStyle(BuildContext context) => TextStyle(
        fontSize: isCompact ? 26 : 32,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      );

  TextStyle? _hintStyle(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white38);
}
