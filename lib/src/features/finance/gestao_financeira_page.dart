import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/widgets/edu_segmented_tabs.dart';
import 'finance_page.dart';
import 'costs_page.dart';
import 'finance_summary_page.dart';

class GestaoFinanceiraPage extends ConsumerStatefulWidget {
  const GestaoFinanceiraPage({super.key});

  @override
  ConsumerState<GestaoFinanceiraPage> createState() => _GestaoFinanceiraPageState();
}

class _GestaoFinanceiraPageState extends ConsumerState<GestaoFinanceiraPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.sizeOf(context).width < 760;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          EduSegmentedTabs(
            controller: _tabController,
            scrollable: isNarrow,
            labels: const ['Resumo', 'Propinas', 'Custos'],
          ),
          SizedBox(height: isNarrow ? 14 : 24),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                FinanceSummaryPage(),
                FinancePage(),
                CostsPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
