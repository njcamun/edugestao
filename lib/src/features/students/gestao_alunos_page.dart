import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
          Container(
            height: isNarrow ? 50 : 54,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.black, width: 2), // Borda brutalista
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: isNarrow,
              tabAlignment: isNarrow ? TabAlignment.start : TabAlignment.fill,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black, // Aba selecionada preenchida de preto
              ),
              labelColor: Colors.white, // Texto branco na aba selecionada
              unselectedLabelColor: Colors.black, // Texto preto na aba não selecionada
              labelStyle: TextStyle(fontWeight: FontWeight.w900, fontSize: isNarrow ? 11 : 13, letterSpacing: 1),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: isNarrow ? 11 : 13),
              tabs: const [
                Tab(text: 'ALUNOS'),
                Tab(text: 'TURMAS'),
                Tab(text: 'MATRÍCULAS'),
              ],
            ),
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
