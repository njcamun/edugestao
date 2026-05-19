import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../domain/entities/horario_aula.dart';
import '../../../shared/widgets/edu_form_styles.dart';
import '../schedules_controller.dart';

class ScheduleFormDialog extends ConsumerStatefulWidget {
  const ScheduleFormDialog({
    super.key,
    required this.turmaId,
    this.existing,
  });

  final String turmaId;
  final HorarioAula? existing;

  @override
  ConsumerState<ScheduleFormDialog> createState() => _ScheduleFormDialogState();
}

class _ScheduleFormDialogState extends ConsumerState<ScheduleFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _inicio;
  late final TextEditingController _fim;
  late final TextEditingController _disciplina;
  late final TextEditingController _professor;
  late int _dia;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _inicio = TextEditingController(text: e?.horaInicio ?? '08:00');
    _fim = TextEditingController(text: e?.horaFim ?? '08:45');
    _disciplina = TextEditingController(text: e?.disciplina ?? '');
    _professor = TextEditingController(text: e?.professor ?? '');
    _dia = e?.diaSemana ?? 1;
  }

  @override
  void dispose() {
    _inicio.dispose();
    _fim.dispose();
    _disciplina.dispose();
    _professor.dispose();
    super.dispose();
  }

  String? _horaValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Obrigatório';
    final parts = v.trim().split(':');
    if (parts.length != 2) return 'Use HH:mm';
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null || h < 0 || h > 23 || m < 0 || m > 59) return 'Hora inválida';
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      await ref.read(scheduleActionsProvider).save(
            existing: widget.existing,
            turmaId: widget.turmaId,
            diaSemana: _dia,
            horaInicio: _inicio.text.trim(),
            horaFim: _fim.text.trim(),
            disciplina: _disciplina.text.trim(),
            professor: _professor.text.trim(),
          );
      if (mounted) Navigator.pop(context);
    } on ScheduleConflictException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: EduFormStyles.dialogShape(),
      child: ConstrainedBox(
        constraints: EduFormStyles.dialogConstraints(context, maxWidth: 440),
        child: Padding(
          padding: EduFormStyles.dialogPadding(context),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  EduFormStyles.dialogHeader(context, widget.existing == null ? 'Nova aula' : 'Editar aula'),
                  const SizedBox(height: AppTokens.paddingMD),
                  DropdownButtonFormField<int>(
                    value: _dia,
                    decoration: EduFormStyles.inputDecoration('Dia', icon: Icons.today_outlined),
                    items: HorarioAula.diasSemana.entries
                        .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                        .toList(),
                    onChanged: (v) => setState(() => _dia = v!),
                  ),
                  const SizedBox(height: AppTokens.paddingMD),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _inicio,
                          decoration: EduFormStyles.inputDecoration('Início', icon: Icons.access_time),
                          validator: _horaValidator,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _fim,
                          decoration: EduFormStyles.inputDecoration('Fim', icon: Icons.access_time_filled),
                          validator: _horaValidator,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTokens.paddingMD),
                  TextFormField(
                    controller: _disciplina,
                    decoration: EduFormStyles.inputDecoration('Disciplina', icon: Icons.menu_book_outlined),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Indique a disciplina' : null,
                  ),
                  const SizedBox(height: AppTokens.paddingMD),
                  TextFormField(
                    controller: _professor,
                    decoration: EduFormStyles.inputDecoration('Professor (opcional)', icon: Icons.person_outline),
                  ),
                  const SizedBox(height: AppTokens.paddingLG),
                  EduFormStyles.dialogActions(
                    onCancel: () => Navigator.pop(context),
                    onConfirm: _isSaving ? null : _submit,
                    confirmLabel: 'Guardar',
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
