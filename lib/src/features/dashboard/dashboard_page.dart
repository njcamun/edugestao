import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../shared/firebase_service.dart';
import 'widgets/dashboard_stats_card.dart';

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
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 900;
                final isCompact = constraints.maxWidth < 640;
                return Column(
                  children: [
                    // Linha 1: KPIs Operacionais
                    FutureBuilder<Map<String, dynamic>>(
                      future: firebase.getOperationalStats(),
                      builder: (context, snapshot) {
                        final active = snapshot.data?['activeEnrollments'] ?? 0;
                        final total = snapshot.data?['totalStudents'] ?? 0;
                        final inactive = snapshot.data?['inactiveStudents'] ?? 0;

                        final avg = snapshot.data?['avgStudentsPerClass'] ?? 0.0;
                        final capacity = snapshot.data?['totalCapacity'] ?? 0;
                        final spots = snapshot.data?['availableSpots'] ?? 0;

                        return GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: isWide ? 2 : 1,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: isWide ? 2.1 : 1.8,
                          children: [
                            DashboardStatsCard(
                              title: 'ALUNOS MATRICULADOS',
                              value: '$active',
                              label1: 'PREVISÃO',
                              value1: '$capacity',
                              label2: 'INSCRITOS',
                              value2: '$total',
                              label3: 'NÃO MATRIC.',
                              value3: '$inactive',
                              subtitle: 'ALUNOS COM MATRÍCULA ATIVA',
                              icon: Icons.people_alt_rounded,
                            ),
                            DashboardStatsCard(
                              title: 'ALUNOS POR TURMA',
                              value: avg.toStringAsFixed(1),
                              label1: 'CAPACIDADE TOTAL',
                              value1: '$capacity',
                              label2: 'VAGAS LIVRES',
                              value2: '$spots',
                              subtitle: 'MÉDIA DE OCUPAÇÃO',
                              icon: Icons.school_rounded,
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Linha 2: Balanço Financeiro
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
                            // Receita e Custos Lado a Lado
                            GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: isWide ? 2 : 1,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: isWide ? 2.1 : 1.8, // Aumentado para acomodar novos dados
                              children: [
                                DashboardStatsCard(
                                  title: 'RECEITA MENSAL',
                                  value: currencyFmt.format(revenuePaid),
                                  label1: 'PREVISÃO',
                                  value1: currencyFmt.format(revenue),
                                  label2: 'PENDENTE',
                                  value2: currencyFmt.format(revenuePending),
                                  subtitle: 'TOTAL RECEBIDO NO MÊS',
                                  icon: Icons.trending_up_rounded,
                                ),
                                DashboardStatsCard(
                                  title: 'CUSTOS MENSAIS',
                                  value: currencyFmt.format(costsPaid),
                                  label1: 'PREVISÃO',
                                  value1: currencyFmt.format(costs),
                                  label2: 'PENDENTE',
                                  value2: currencyFmt.format(costsPending),
                                  subtitle: 'TOTAL PAGO NO MÊS',
                                  icon: Icons.trending_down_rounded,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            
                            // Saldo Abaixo (Destaque)
                            Container(
                              padding: EdgeInsets.all(isCompact ? 16 : 24),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.black, width: 2),
                                boxShadow: const [
                                  BoxShadow(color: Colors.black26, offset: Offset(4, 4), blurRadius: 0),
                                ],
                              ),
                              child: isCompact
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 28),
                                        const SizedBox(height: 10),
                                        const Text(
                                          'SALDO LÍQUIDO DO MÊS',
                                          style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.2),
                                        ),
                                        const SizedBox(height: 4),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            currencyFmt.format(balance),
                                            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        const Text(
                                          'VALOR DISPONÍVEL APÓS DEDUÇÃO DE DESPESAS',
                                          style: TextStyle(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 40),
                                        const SizedBox(width: 24),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'SALDO LÍQUIDO DO MÊS',
                                                style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.5),
                                              ),
                                              const SizedBox(height: 4),
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  currencyFmt.format(balance),
                                                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white),
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              const Text(
                                                'VALOR DISPONÍVEL APÓS DEDUÇÃO DE DESPESAS',
                                                style: TextStyle(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ],
                        );
                      },
                    ),
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
