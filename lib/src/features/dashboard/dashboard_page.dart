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
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: isWide ? 2 : 1,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: isWide ? 2.5 : 2.5,
                      children: [
                        StreamBuilder<int>(
                          stream: firebase.streamTotalStudents(),
                          builder: (context, snapshot) => DashboardStatsCard(
                            title: 'ALUNOS INSCRITOS',
                            value: '${snapshot.data ?? 0}',
                            subtitle: 'STATUS ACTIVO NA CLOUD',
                            icon: Icons.people_alt_rounded,
                          ),
                        ),
                        StreamBuilder<int>(
                          stream: firebase.streamTotalClasses(),
                          builder: (context, snapshot) => DashboardStatsCard(
                            title: 'TURMAS ACTIVAS',
                            value: '${snapshot.data ?? 0}',
                            subtitle: 'ANO LECTIVO CORRENTE',
                            icon: Icons.school_rounded,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Linha 2: Balanço Financeiro
                    FutureBuilder<Map<String, dynamic>>(
                      future: firebase.getFinanceStats(),
                      builder: (context, snapshot) {
                        final revenue = snapshot.data?['monthlyRevenue'] ?? 0.0;
                        final costs = snapshot.data?['monthlyCosts'] ?? 0.0;
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
                              childAspectRatio: isWide ? 2.5 : 2.5,
                              children: [
                                DashboardStatsCard(
                                  title: 'RECEITA MENSAL',
                                  value: currencyFmt.format(revenue),
                                  subtitle: 'PROPINAS LIQUIDADAS',
                                  icon: Icons.trending_up_rounded,
                                ),
                                DashboardStatsCard(
                                  title: 'CUSTOS MENSAIS',
                                  value: currencyFmt.format(costs),
                                  subtitle: 'SAÍDAS DO INVENTÁRIO',
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
