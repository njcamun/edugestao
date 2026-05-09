import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  // Estados para os filtros
  String _selectedAnoLectivo = '2024/2025';
  String _selectedPeriodicidade = 'ANUAL';
  String? _selectedTurmaId;
  String? _selectedTurno;

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
          _buildSectionHeader('INDICADORES ACADÉMICOS'),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 600;
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isWide ? 2 : 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: isWide ? 3.5 : 4,
                children: [
                  _ReportKpiCard(title: 'TOTAL ALUNOS', value: '${students.length}', icon: Icons.people_alt_rounded),
                  _ReportKpiCard(title: 'VAGAS DISPONÍVEIS', value: '${totalVagas - ocupacao}', icon: Icons.event_seat_rounded),
                ],
              );
            },
          ),
          const SizedBox(height: 40),
          _buildSectionHeader('GERAÇÃO DE DOCUMENTOS'),
          const SizedBox(height: 16),
          
          _ExportActionTile(
            label: 'GERAR RELATÓRIOS ACADÉMICOS',
            subtitle: 'Clique para filtrar por classe, turma, turno ou período.',
            icon: Icons.assignment_rounded,
            onTap: () => _showFilterDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.black, letterSpacing: 1.5),
    );
  }

  void _showFilterDialog(BuildContext context) {
    final classes = ref.read(classesStreamProvider).value ?? [];
    final config = ref.read(settingsProvider).value;
    final students = ref.read(studentsStreamProvider).value ?? [];
    final enrollments = ref.read(enrollmentsStreamProvider).value ?? [];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.black, width: 2)),
          title: const Text('FILTROS DO RELATÓRIO', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogDropdown('PERIODICIDADE', ['MENSAL', 'TRIMESTRAL', 'ANUAL'], _selectedPeriodicidade, (v) => setDialogState(() => _selectedPeriodicidade = v!)),
                const SizedBox(height: 12),
                _buildDialogDropdown('ANO LECTIVO', ['2024/2025', '2023/2024'], _selectedAnoLectivo, (v) => setDialogState(() => _selectedAnoLectivo = v!)),
                const SizedBox(height: 12),
                _buildDialogDropdown('TURNO', ['TODOS', 'MANHÃ', 'TARDE', 'NOITE'], _selectedTurno ?? 'TODOS', (v) => setDialogState(() => _selectedTurno = v == 'TODOS' ? null : v)),
                const SizedBox(height: 12),
                _buildDialogDropdown(
                  'TURMA ESPECÍFICA', 
                  ['TODAS', ...classes.map((t) => t.nomeTurma)], 
                  _selectedTurmaId ?? 'TODAS', 
                  (v) => setDialogState(() => _selectedTurmaId = v == 'TODAS' ? null : v)
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
            FilledButton(
              onPressed: () async {
                Navigator.pop(context);
                // Aqui chamamos o gerador passando os filtros selecionados
                await ReportPdfGenerator.generateStudentList(
                  alunos: students,
                  matriculas: enrollments,
                  turmas: classes,
                  anoLectivo: _selectedAnoLectivo,
                  config: config,
                  // Adicionar lógica de filtro no gerador baseado nos estados acima
                );
              },
              style: FilledButton.styleFrom(backgroundColor: Colors.black),
              child: const Text('GERAR PDF'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogDropdown(String label, List<String> items, String value, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 12)))).toList(),
      onChanged: onChanged,
    );
  }
}

class _ReportKpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  const _ReportKpiCard({required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black, width: 2), borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Icon(icon, color: Colors.black, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.black54)),
                FittedBox(fit: BoxFit.scaleDown, child: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.black))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExportActionTile extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  const _ExportActionTile({required this.label, required this.subtitle, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black, width: 1.5), borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Icon(icon, color: Colors.black, size: 24),
        title: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.black)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.black54, fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.black),
        onTap: onTap,
      ),
    );
  }
}
