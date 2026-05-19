import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_tokens.dart';
import '../../domain/entities/aluno.dart';
import '../../domain/entities/nota_avaliacao.dart';
import '../../shared/widgets/edu_card.dart';
import '../../shared/widgets/edu_empty_state.dart';
import '../classes/classes_controller.dart';
import '../enrollments/enrollments_controller.dart';
import '../students/students_controller.dart';
import 'grades_controller.dart';
import '../settings/settings_controller.dart';
import 'services/grades_csv_export.dart';
import 'utils/grades_lookup.dart';
import 'widgets/grade_form_dialog.dart';
import 'widgets/grades_boletim_pdf.dart';

class GradesPage extends ConsumerStatefulWidget {
  const GradesPage({super.key});

  @override
  ConsumerState<GradesPage> createState() => _GradesPageState();
}

class _GradesPageState extends ConsumerState<GradesPage> {
  final _disciplina = TextEditingController();
  final _ano = TextEditingController(text: '${DateTime.now().year}');

  void _applyFilters() {
    final filter = ref.read(gradesFilterProvider);
    ref.read(gradesFilterProvider.notifier).state = (
      trimestre: filter.trimestre,
      disciplina: _disciplina.text.trim(),
      anoLectivo: _ano.text.trim(),
    );
  }

  @override
  void dispose() {
    _disciplina.dispose();
    _ano.dispose();
    super.dispose();
  }

  String _nomeAluno(Map<String, String> nomes, String alunoId) => nomes[alunoId] ?? alunoId;

  Map<String, String> _turmasLookup(List<Aluno> alunos, String anoLectivo) {
    final matriculas = ref.read(enrollmentsStreamProvider).valueOrNull ?? [];
    final turmas = ref.read(classesStreamProvider).valueOrNull ?? [];
    return GradesLookup.turmasPorAluno(
      alunos: alunos,
      anoLectivo: anoLectivo,
      matriculas: matriculas,
      turmas: turmas,
    );
  }

  Future<void> _exportPdf() async {
    final filter = ref.read(gradesFilterProvider);
    final notas = ref.read(gradesStreamProvider).valueOrNull ?? [];
    if (notas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não há notas para exportar com os filtros actuais.')),
      );
      return;
    }
    final alunos = ref.read(studentsStreamProvider).valueOrNull ?? [];
    final comNotas = alunos.where((a) => notas.any((n) => n.alunoId == a.id)).toList();
    final config = ref.read(settingsProvider).valueOrNull;
    await GradesBoletimPdf.generateTurma(
      alunos: comNotas,
      notas: notas,
      trimestre: filter.trimestre,
      anoLectivo: filter.anoLectivo,
      config: config,
      turmaPorAluno: _turmasLookup(comNotas, filter.anoLectivo),
    );
  }

  Future<void> _exportCsv() async {
    final filter = ref.read(gradesFilterProvider);
    final notas = ref.read(gradesStreamProvider).valueOrNull ?? [];
    if (notas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não há notas para exportar.')),
      );
      return;
    }
    final alunos = ref.read(studentsStreamProvider).valueOrNull ?? [];
    final nomes = {for (final a in alunos) a.id: a.nomeCompleto};
    final numeros = {for (final a in alunos) a.id: a.numeroAluno};
    final turmas = _turmasLookup(alunos, filter.anoLectivo);
    final ok = await GradesCsvExport.save(
      notas: notas,
      alunoNomes: nomes,
      alunoNumeros: numeros,
      turmaPorAluno: turmas,
      trimestre: filter.trimestre,
      anoLectivo: filter.anoLectivo,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ok ? 'Ficheiro CSV guardado.' : 'Exportação cancelada.')),
    );
  }

  void _openForm({NotaAvaliacao? existing}) {
    final filter = ref.read(gradesFilterProvider);
    showDialog(
      context: context,
      builder: (_) => GradeFormDialog(
        existing: existing,
        defaultTrimestre: filter.trimestre,
        defaultAnoLectivo: filter.anoLectivo,
      ),
    );
  }

  Map<String, ({double media, int count})> _resumoPorAluno(List<NotaAvaliacao> notas) {
    final map = <String, List<double>>{};
    for (final n in notas) {
      map.putIfAbsent(n.alunoId, () => []).add(n.valor);
    }
    return {
      for (final e in map.entries)
        e.key: (media: e.value.reduce((a, b) => a + b) / e.value.length, count: e.value.length),
    };
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(gradesFilterProvider);
    final viewMode = ref.watch(gradesViewModeProvider);
    final notasAsync = ref.watch(gradesStreamProvider);
    final alunos = ref.watch(studentsStreamProvider).valueOrNull ?? [];
    final nomes = {for (final a in alunos) a.id: a.nomeCompleto};

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            heroTag: 'grades_csv',
            onPressed: _exportCsv,
            backgroundColor: AppTokens.surface,
            foregroundColor: AppTokens.primary,
            child: const Icon(Icons.table_chart_outlined),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            heroTag: 'grades_pdf',
            onPressed: _exportPdf,
            backgroundColor: AppTokens.surface,
            foregroundColor: AppTokens.primary,
            child: const Icon(Icons.picture_as_pdf_outlined),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: 'grades_add',
            onPressed: () => _openForm(),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Lançar nota'),
            backgroundColor: AppTokens.primary,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              DropdownButton<int>(
                value: filter.trimestre,
                items: const [
                  DropdownMenuItem(value: 1, child: Text('1º Trimestre')),
                  DropdownMenuItem(value: 2, child: Text('2º Trimestre')),
                  DropdownMenuItem(value: 3, child: Text('3º Trimestre')),
                ],
                onChanged: (v) {
                  if (v == null) return;
                  ref.read(gradesFilterProvider.notifier).state = (
                    trimestre: v,
                    disciplina: filter.disciplina,
                    anoLectivo: filter.anoLectivo,
                  );
                },
              ),
              SizedBox(
                width: 160,
                child: TextField(
                  controller: _ano,
                  onChanged: (_) => _applyFilters(),
                  decoration: InputDecoration(
                    labelText: 'Ano lectivo',
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTokens.radiusMD)),
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: _disciplina,
                  onChanged: (_) => _applyFilters(),
                  decoration: InputDecoration(
                    hintText: 'Filtrar disciplina...',
                    prefixIcon: const Icon(Icons.filter_list_rounded, size: 20),
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTokens.radiusMD)),
                  ),
                ),
              ),
              SegmentedButton<GradesViewMode>(
                segments: const [
                  ButtonSegment(value: GradesViewMode.notas, label: Text('Notas'), icon: Icon(Icons.list_rounded, size: 18)),
                  ButtonSegment(value: GradesViewMode.resumoAlunos, label: Text('Médias'), icon: Icon(Icons.people_outline, size: 18)),
                ],
                selected: {viewMode},
                onSelectionChanged: (s) => ref.read(gradesViewModeProvider.notifier).state = s.first,
              ),
            ],
          ),
          const SizedBox(height: AppTokens.paddingMD),
          Expanded(
            child: notasAsync.when(
              data: (notas) {
                if (notas.isEmpty) {
                  return EduEmptyState(
                    icon: Icons.grade_outlined,
                    title: 'Sem notas',
                    message: filter.disciplina.isEmpty
                        ? 'Não há notas para ${NotaAvaliacao.trimestreLabel(filter.trimestre)}.'
                        : 'Nenhuma nota para a disciplina indicada.',
                    actionLabel: 'Lançar nota',
                    onAction: () => _openForm(),
                  );
                }

                if (viewMode == GradesViewMode.resumoAlunos) {
                  final resumo = _resumoPorAluno(notas);
                  final ids = resumo.keys.toList()
                    ..sort((a, b) => _nomeAluno(nomes, a).compareTo(_nomeAluno(nomes, b)));
                  return ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: ids.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppTokens.paddingSM),
                    itemBuilder: (context, index) {
                      final alunoId = ids[index];
                      final r = resumo[alunoId]!;
                      return EduCard(
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppTokens.primary.withValues(alpha: 0.12),
                              child: Text(
                                r.media.toStringAsFixed(1),
                                style: const TextStyle(color: AppTokens.primaryDark, fontWeight: FontWeight.w700, fontSize: 13),
                              ),
                            ),
                            const SizedBox(width: AppTokens.paddingMD),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_nomeAluno(nomes, alunoId), style: const TextStyle(fontWeight: FontWeight.w600)),
                                  Text(
                                    'Média · ${r.count} disciplina${r.count == 1 ? '' : 's'}',
                                    style: const TextStyle(fontSize: 13, color: AppTokens.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }

                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: notas.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppTokens.paddingSM),
                  itemBuilder: (context, index) {
                    final n = notas[index];
                    return EduCard(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(AppTokens.radiusMD),
                        onTap: () => _openForm(existing: n),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppTokens.primary.withValues(alpha: 0.12),
                              child: Text(
                                n.valor.toStringAsFixed(0),
                                style: const TextStyle(
                                  color: AppTokens.primaryDark,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppTokens.paddingMD),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _nomeAluno(nomes, n.alunoId),
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '${n.disciplina} · ${n.valor.toStringAsFixed(1)} valores',
                                    style: const TextStyle(fontSize: 13, color: AppTokens.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (v) async {
                                if (v == 'edit') {
                                  _openForm(existing: n);
                                } else if (v == 'delete') {
                                  final ok = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Remover nota?'),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
                                        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Remover')),
                                      ],
                                    ),
                                  );
                                  if (ok == true) await ref.read(gradeActionsProvider).delete(n.id);
                                }
                              },
                              itemBuilder: (_) => const [
                                PopupMenuItem(value: 'edit', child: Text('Editar')),
                                PopupMenuItem(value: 'delete', child: Text('Remover')),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: AppTokens.primary)),
              error: (e, _) => EduEmptyState(icon: Icons.error_outline, title: 'Erro', message: '$e'),
            ),
          ),
        ],
      ),
    );
  }
}
