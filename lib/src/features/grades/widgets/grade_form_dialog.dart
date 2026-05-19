import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../domain/entities/aluno.dart';
import '../../../domain/entities/nota_avaliacao.dart';
import '../../../shared/widgets/edu_form_styles.dart';
import '../../students/students_controller.dart';
import '../grades_controller.dart';

class GradeFormDialog extends ConsumerStatefulWidget {
  const GradeFormDialog({super.key, this.existing, this.defaultTrimestre = 1, this.defaultAnoLectivo});

  final NotaAvaliacao? existing;
  final int defaultTrimestre;
  final String? defaultAnoLectivo;

  @override
  ConsumerState<GradeFormDialog> createState() => _GradeFormDialogState();
}

class _GradeFormDialogState extends ConsumerState<GradeFormDialog> {
  final _formKey = GlobalKey<FormState>();
  Aluno? _aluno;
  late final TextEditingController _disciplina;
  late final TextEditingController _valor;
  late final TextEditingController _ano;
  late final TextEditingController _obs;
  late int _trimestre;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _disciplina = TextEditingController(text: e?.disciplina ?? '');
    _valor = TextEditingController(text: e != null ? e.valor.toStringAsFixed(1) : '');
    _ano = TextEditingController(text: e?.anoLectivo ?? widget.defaultAnoLectivo ?? '${DateTime.now().year}');
    _obs = TextEditingController(text: e?.observacao ?? '');
    _trimestre = e?.trimestre ?? widget.defaultTrimestre;
  }

  @override
  void dispose() {
    _disciplina.dispose();
    _valor.dispose();
    _ano.dispose();
    _obs.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final alunoId = widget.existing?.alunoId ?? _aluno?.id;
    if (alunoId == null) return;

    setState(() => _isSaving = true);
    try {
      await ref.read(gradeActionsProvider).save(
            existing: widget.existing,
            alunoId: alunoId,
            disciplina: _disciplina.text.trim(),
            trimestre: _trimestre,
            anoLectivo: _ano.text.trim(),
            valor: double.parse(_valor.text.replaceAll(',', '.')),
            observacao: _obs.text.trim(),
          );
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final alunos = (ref.watch(studentsStreamProvider).valueOrNull ?? [])
        .where((a) => a.status == AlunoStatus.ativo)
        .toList();

    Aluno? alunoExistente;
    if (widget.existing != null) {
      for (final a in alunos) {
        if (a.id == widget.existing!.alunoId) {
          alunoExistente = a;
          break;
        }
      }
    }

    return Dialog(
      shape: EduFormStyles.dialogShape(),
      child: ConstrainedBox(
        constraints: EduFormStyles.dialogConstraints(context, maxWidth: 460),
        child: Padding(
          padding: EduFormStyles.dialogPadding(context),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  EduFormStyles.dialogHeader(context, widget.existing == null ? 'Lançar nota' : 'Editar nota'),
                  const SizedBox(height: AppTokens.paddingMD),
                  if (widget.existing == null)
                    DropdownButtonFormField<Aluno>(
                      value: _aluno,
                      decoration: EduFormStyles.inputDecoration('Aluno', icon: Icons.person_outline_rounded),
                      items: alunos.map((a) => DropdownMenuItem(value: a, child: Text(a.nomeCompleto))).toList(),
                      onChanged: (v) => setState(() => _aluno = v),
                      validator: (v) => v == null ? 'Seleccione o aluno' : null,
                    )
                  else
                    TextFormField(
                      initialValue: alunoExistente?.nomeCompleto ?? widget.existing!.alunoId,
                      enabled: false,
                      decoration: EduFormStyles.inputDecoration('Aluno', icon: Icons.person_outline_rounded, enabled: false),
                    ),
                  const SizedBox(height: AppTokens.paddingMD),
                  TextFormField(
                    controller: _disciplina,
                    decoration: EduFormStyles.inputDecoration('Disciplina', icon: Icons.menu_book_outlined),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Indique a disciplina' : null,
                  ),
                  const SizedBox(height: AppTokens.paddingMD),
                  DropdownButtonFormField<int>(
                    value: _trimestre,
                    decoration: EduFormStyles.inputDecoration('Trimestre', icon: Icons.calendar_view_month_outlined),
                    items: const [
                      DropdownMenuItem(value: 1, child: Text('1º Trimestre')),
                      DropdownMenuItem(value: 2, child: Text('2º Trimestre')),
                      DropdownMenuItem(value: 3, child: Text('3º Trimestre')),
                    ],
                    onChanged: (v) => setState(() => _trimestre = v!),
                  ),
                  const SizedBox(height: AppTokens.paddingMD),
                  TextFormField(
                    controller: _ano,
                    decoration: EduFormStyles.inputDecoration('Ano lectivo', icon: Icons.school_outlined),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Indique o ano lectivo' : null,
                  ),
                  const SizedBox(height: AppTokens.paddingMD),
                  TextFormField(
                    controller: _valor,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: EduFormStyles.inputDecoration('Nota (0–20)', icon: Icons.grade_outlined),
                    validator: (v) {
                      final n = double.tryParse((v ?? '').replaceAll(',', '.'));
                      if (n == null) return 'Valor inválido';
                      if (n < 0 || n > 20) return 'A nota deve estar entre 0 e 20';
                      return null;
                    },
                  ),
                  const SizedBox(height: AppTokens.paddingMD),
                  TextFormField(
                    controller: _obs,
                    maxLines: 2,
                    decoration: EduFormStyles.inputDecoration('Observação (opcional)', icon: Icons.notes_outlined),
                  ),
                  const SizedBox(height: AppTokens.paddingLG),
                  EduFormStyles.dialogActions(
                    onCancel: () => Navigator.pop(context),
                    onConfirm: _isSaving ? null : _submit,
                    confirmLabel: widget.existing == null ? 'Guardar' : 'Actualizar',
                    isLoading: _isSaving,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
