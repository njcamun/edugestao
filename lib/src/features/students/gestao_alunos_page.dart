import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/widgets/edu_segmented_tabs.dart';
import 'students_page.dart';
import '../classes/classes_page.dart';
import '../enrollments/enrollments_page.dart';

class GestaoAlunosPage extends ConsumerStatefulWidget {
  const GestaoAlunosPage({super.key});

  @override
  ConsumerState<GestaoAlunosPage> createState() => _GestaoAlunosPageState();
}

class _GestaoAlunosPageState extends ConsumerState<GestaoAlunosPage> with SingleTickerProviderStateMixin {
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
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = width < 720;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EduSegmentedTabs(
            controller: _tabController,
            scrollable: isNarrow,
            labels: const ['Alunos', 'Turmas', 'Matrículas'],
          ),
          
          SizedBox(height: isNarrow ? 16 : 32),
          
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                StudentsPage(),
                ClassesPage(),
                EnrollmentsPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
