import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_tokens.dart';
import '../../shared/widgets/edu_section_title.dart';
import '../../shared/widgets/report_export_tile.dart';
import '../../shared/widgets/report_kpi_card.dart';
import '../students/students_controller.dart';
import '../classes/classes_controller.dart';
import '../enrollments/enrollments_controller.dart';
import '../settings/settings_controller.dart';
import 'widgets/report_pdf_generator.dart';

class ReportStudentsPage extends ConsumerStatefulWidget {
  const ReportStudentsPage({super.key});

  @override
  ConsumerState<ReportStudentsPage> createState() => _ReportStudentsPageState();
}

class _ReportStudentsPageState extends ConsumerState<ReportStudentsPage> {
  String _selectedAnoLectivo = '2024/2025';
  String _selectedPeriodicidade = 'Anual';
  String? _selectedTurmaId;

  @override
  Widget build(BuildContext context) {
    final students = ref.watch(studentsStreamProvider).value ?? [];
    final classes = ref.watch(classesStreamProvider).value ?? [];
    final enrollments = ref.watch(enrollmentsStreamProvider).value ?? [];

    final totalVagas = classes.fold(0, (sum, c) => sum + c.limiteAlunos);
    final ocupacao = enrollments.where((e) => e.estado == 'ativa').length;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const EduSectionTitle('Indicadores académicos'),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 600;
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isWide ? 2 : 1,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: isWide ? 3.2 : 3.8,
                children: [
                  ReportKpiCard(
                    title: 'Total de alunos',
                    value: '${students.length}',
                    icon: Icons.people_alt_rounded,
                  ),
                  ReportKpiCard(
                    title: 'Vagas disponíveis',
                    value: '${totalVagas - ocupacao}',
                    icon: Icons.event_seat_rounded,
                    accentColor: AppTokens.accentPurple,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 28),
          const EduSectionTitle('Geração de documentos'),
          ReportExportTile(
            label: 'Relatório de alunos',
            subtitle: 'Filtrar por ano lectivo, turma ou turno.',
            icon: Icons.assignment_rounded,
            onTap: () => _showFilterDialog(context),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    final classes = ref.read(classesStreamProvider).value ?? [];
    final config = ref.read(settingsProvider).value;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Filtros do relatório'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _selectedAnoLectivo,
                  decoration: const InputDecoration(labelText: 'Ano lectivo'),
                  items: ['2024/2025', '2025/2026']
                      .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedAnoLectivo = v ?? _selectedAnoLectivo),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _selectedPeriodicidade,
                  decoration: const InputDecoration(labelText: 'Periodicidade'),
                  items: ['Anual', 'Mensal', 'Trimestral']
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedPeriodicidade = v ?? _selectedPeriodicidade),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String?>(
                  initialValue: _selectedTurmaId,
                  decoration: const InputDecoration(labelText: 'Turma'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Todas')),
                    ...classes.map((c) => DropdownMenuItem(value: c.id, child: Text(c.nomeTurma))),
                  ],
                  onChanged: (v) => setState(() => _selectedTurmaId = v),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
            FilledButton(
              onPressed: () async {
                Navigator.pop(ctx);
                final students = ref.read(studentsStreamProvider).value ?? [];
                final enrollments = ref.read(enrollmentsStreamProvider).value ?? [];
                final turmas = ref.read(classesStreamProvider).value ?? [];

                var filteredEnrollments =
                    enrollments.where((e) => e.anoLectivo == _selectedAnoLectivo && e.estado == 'ativa');
                if (_selectedTurmaId != null) {
                  filteredEnrollments = filteredEnrollments.where((e) => e.turmaId == _selectedTurmaId);
                }
                final alunoIds = filteredEnrollments.map((e) => e.alunoId).toSet();
                final filteredStudents = students.where((s) => alunoIds.contains(s.id)).toList();

                await ReportPdfGenerator.generateStudentList(
                  alunos: filteredStudents,
                  matriculas: filteredEnrollments.toList(),
                  turmas: turmas,
                  anoLectivo: _selectedAnoLectivo,
                  config: config,
                );
              },
              child: const Text('Gerar PDF'),
            ),
          ],
        ),
      ),
    );
  }
}
