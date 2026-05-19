import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/widgets/edu_segmented_tabs.dart';
import 'report_students_page.dart';
import 'report_finance_page.dart';
import 'report_grades_page.dart';

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
            labels: const ['Alunos', 'Financeiro', 'Notas'],
          ),
          SizedBox(height: isNarrow ? 14 : 24),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                ReportStudentsPage(),
                ReportFinancePage(),
                ReportGradesPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
