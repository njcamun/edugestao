import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'report_students_page.dart';
import 'report_finance_page.dart';

class ReportsPage extends ConsumerStatefulWidget {
  const ReportsPage({super.key});

  @override
  ConsumerState<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends ConsumerState<ReportsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = width < 760;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Container(
            height: isNarrow ? 50 : 54,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: isNarrow,
              tabAlignment: isNarrow ? TabAlignment.start : TabAlignment.fill,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              labelStyle: TextStyle(fontWeight: FontWeight.w900, fontSize: isNarrow ? 10 : 12, letterSpacing: 1),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: isNarrow ? 10 : 12),
              tabs: const [
                Tab(text: 'RELATÓRIO ALUNOS'),
                Tab(text: 'RELATÓRIO FINANCEIRO'),
              ],
            ),
          ),
          SizedBox(height: isNarrow ? 14 : 24),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                ReportStudentsPage(),
                ReportFinancePage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
