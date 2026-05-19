import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_tokens.dart';
import '../../domain/entities/aluno.dart';
import '../../domain/entities/nota_avaliacao.dart';
import '../../shared/widgets/edu_section_title.dart';
import '../../shared/widgets/report_export_tile.dart';
import '../classes/classes_controller.dart';
import '../enrollments/enrollments_controller.dart';
import '../grades/grades_controller.dart';
import '../grades/services/grades_csv_export.dart';
import '../grades/utils/grades_lookup.dart';
import '../grades/widgets/grades_boletim_pdf.dart';
import '../grades/widgets/grades_pauta_pdf.dart';
import '../../domain/entities/turma.dart';
import '../settings/settings_controller.dart';
import '../students/students_controller.dart';

class ReportGradesPage extends ConsumerStatefulWidget {
  const ReportGradesPage({super.key});

  @override
  ConsumerState<ReportGradesPage> createState() => _ReportGradesPageState();
}

class _ReportGradesPageState extends ConsumerState<ReportGradesPage> {
  int _trimestre = 1;
  String _anoLectivo = '${DateTime.now().year}';
  String? _alunoId;
  String? _turmaId;
  bool _exportingPdf = false;
  bool _exportingCsv = false;
  bool _exportingPauta = false;

  Future<List<NotaAvaliacao>> _loadNotas() async {
    ref.read(gradesFilterProvider.notifier).state = (
      trimestre: _trimestre,
      disciplina: '',
      anoLectivo: _anoLectivo,
    );
    return ref.read(gradesStreamProvider.future);
  }

  Map<String, String> _turmasLookup(List<Aluno> alunos) {
    return GradesLookup.turmasPorAluno(
      alunos: alunos,
      anoLectivo: _anoLectivo,
      matriculas: ref.read(enrollmentsStreamProvider).valueOrNull ?? [],
      turmas: ref.read(classesStreamProvider).valueOrNull ?? [],
    );
  }

  Future<void> _exportPdf() async {
    setState(() => _exportingPdf = true);
    try {
      final notas = await _loadNotas();
      final alunos = ref.read(studentsStreamProvider).valueOrNull ?? [];
      final config = ref.read(settingsProvider).valueOrNull;

      if (_alunoId != null) {
        Aluno? aluno;
        for (final a in alunos) {
          if (a.id == _alunoId) {
            aluno = a;
            break;
          }
        }
        if (aluno == null) return;
        final notasAluno = notas.where((n) => n.alunoId == aluno!.id).toList();
        if (notasAluno.isEmpty) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Este aluno não tem notas no período seleccionado.')),
            );
          }
          return;
        }
        await GradesBoletimPdf.generateAluno(
          aluno: aluno,
          notas: notasAluno,
          trimestre: _trimestre,
          anoLectivo: _anoLectivo,
          config: config,
          turmaNome: _turmasLookup(alunos)[aluno.id],
        );
      } else {
        final comNotas = alunos.where((a) => notas.any((n) => n.alunoId == a.id)).toList();
        if (comNotas.isEmpty) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Não há notas para exportar no período seleccionado.')),
            );
          }
          return;
        }
        await GradesBoletimPdf.generateTurma(
          alunos: comNotas,
          notas: notas,
          trimestre: _trimestre,
          anoLectivo: _anoLectivo,
          config: config,
          turmaPorAluno: _turmasLookup(comNotas),
        );
      }
    } finally {
      if (mounted) setState(() => _exportingPdf = false);
    }
  }

  Future<void> _exportCsv() async {
    setState(() => _exportingCsv = true);
    try {
      final notas = await _loadNotas();
      if (notas.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Não há notas para exportar.')),
          );
        }
        return;
      }
      final alunos = ref.read(studentsStreamProvider).valueOrNull ?? [];
      final nomes = {for (final a in alunos) a.id: a.nomeCompleto};
      final numeros = {for (final a in alunos) a.id: a.numeroAluno};
      final ok = await GradesCsvExport.save(
        notas: notas,
        alunoNomes: nomes,
        alunoNumeros: numeros,
        turmaPorAluno: _turmasLookup(alunos),
        trimestre: _trimestre,
        anoLectivo: _anoLectivo,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ok ? 'CSV guardado (compatível com Excel).' : 'Exportação cancelada.')),
        );
      }
    } finally {
      if (mounted) setState(() => _exportingCsv = false);
    }
  }

  Future<void> _exportPauta() async {
    if (_turmaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seleccione uma turma para a pauta.')),
      );
      return;
    }
    setState(() => _exportingPauta = true);
    try {
      final notas = await _loadNotas();
      final alunos = ref.read(studentsStreamProvider).valueOrNull ?? [];
      final turmas = ref.read(classesStreamProvider).valueOrNull ?? [];
      Turma? turma;
      for (final t in turmas) {
        if (t.id == _turmaId) {
          turma = t;
          break;
        }
      }
      if (turma == null) return;

      final alunosTurma = GradesLookup.alunosDaTurma(
        turmaId: turma.id,
        alunos: alunos,
        matriculas: ref.read(enrollmentsStreamProvider).valueOrNull ?? [],
      );
      final notasTurma = notas.where((n) => alunosTurma.any((a) => a.id == n.alunoId)).toList();
      if (notasTurma.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Não há notas para esta turma no período.')),
          );
        }
        return;
      }
      await GradesPautaPdf.generate(
        turma: turma,
        alunos: alunosTurma,
        notas: notasTurma,
        trimestre: _trimestre,
        anoLectivo: _anoLectivo,
        config: ref.read(settingsProvider).valueOrNull,
      );
    } finally {
      if (mounted) setState(() => _exportingPauta = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final alunos = ref.watch(studentsStreamProvider).valueOrNull ?? [];
    final activos = alunos.where((a) => a.status == AlunoStatus.ativo).toList();
    final turmas = ref.watch(classesStreamProvider).valueOrNull ?? [];
    final turmasActivas = turmas.where((t) => !t.isDeleted && t.ativa).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const EduSectionTitle('Exportação de notas'),
          Text(
            'Boletim, pauta da turma ou CSV para Excel.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTokens.textSecondary),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: 180,
                child: DropdownButtonFormField<int>(
                  initialValue: _trimestre,
                  decoration: const InputDecoration(labelText: 'Trimestre', isDense: true),
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('1º Trimestre')),
                    DropdownMenuItem(value: 2, child: Text('2º Trimestre')),
                    DropdownMenuItem(value: 3, child: Text('3º Trimestre')),
                  ],
                  onChanged: (v) => setState(() => _trimestre = v!),
                ),
              ),
              SizedBox(
                width: 140,
                child: TextFormField(
                  initialValue: _anoLectivo,
                  decoration: const InputDecoration(labelText: 'Ano lectivo', isDense: true),
                  onChanged: (v) => _anoLectivo = v.trim(),
                ),
              ),
              SizedBox(
                width: 260,
                child: DropdownButtonFormField<String?>(
                  initialValue: _alunoId,
                  decoration: const InputDecoration(labelText: 'Aluno (opcional)', isDense: true),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Todos com notas')),
                    ...activos.map((a) => DropdownMenuItem(value: a.id, child: Text(a.nomeCompleto))),
                  ],
                  onChanged: (v) => setState(() => _alunoId = v),
                ),
              ),
              SizedBox(
                width: 220,
                child: DropdownButtonFormField<String?>(
                  initialValue: _turmaId,
                  decoration: const InputDecoration(labelText: 'Turma (pauta)', isDense: true),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('—')),
                    ...turmasActivas.map((t) => DropdownMenuItem(value: t.id, child: Text(t.nomeTurma))),
                  ],
                  onChanged: (v) => setState(() => _turmaId = v),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ReportExportTile(
            label: _exportingPdf ? 'A gerar PDF...' : 'Exportar boletim PDF',
            subtitle: 'Inclui turma e encarregado de educação.',
            icon: Icons.picture_as_pdf_outlined,
            onTap: _exportingPdf ? () {} : _exportPdf,
          ),
          ReportExportTile(
            label: _exportingPauta ? 'A gerar pauta...' : 'Pauta da turma (PDF)',
            subtitle: 'Tabela alunos × disciplinas em formato paisagem.',
            icon: Icons.grid_on_outlined,
            onTap: _exportingPauta ? () {} : _exportPauta,
          ),
          ReportExportTile(
            label: _exportingCsv ? 'A exportar...' : 'Exportar CSV (Excel)',
            subtitle: 'Separador ; e codificação UTF-8 com BOM.',
            icon: Icons.table_chart_outlined,
            onTap: _exportingCsv ? () {} : _exportCsv,
          ),
        ],
      ),
    );
  }
}
