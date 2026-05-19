import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../domain/entities/funcionario.dart';
import '../../../shared/widgets/edu_form_styles.dart';
import '../../staff/staff_controller.dart';
import '../salaries_controller.dart';

class SalaryFormDialog extends ConsumerStatefulWidget {
  const SalaryFormDialog({super.key});

  @override
  ConsumerState<SalaryFormDialog> createState() => _SalaryFormDialogState();
}

class _SalaryFormDialogState extends ConsumerState<SalaryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  Funcionario? _selected;
  final _descontos = TextEditingController(text: '0');
  final _bonus = TextEditingController(text: '0');
  final _obs = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _descontos.dispose();
    _bonus.dispose();
    _obs.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selected == null) return;
    setState(() => _isSaving = true);
    try {
      await ref.read(salaryActionsProvider).processar(
            funcionarioId: _selected!.id,
            funcionarioNome: _selected!.nomeCompleto,
            valorBase: _selected!.salarioBase,
            descontos: double.tryParse(_descontos.text.replaceAll(',', '.')) ?? 0,
            bonus: double.tryParse(_bonus.text.replaceAll(',', '.')) ?? 0,
            observacao: _obs.text.trim().isEmpty ? null : _obs.text.trim(),
          );
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final staff = ref.watch(staffStreamProvider).valueOrNull ?? [];

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
                  EduFormStyles.dialogHeader(context, 'Processar salário'),
                  const SizedBox(height: AppTokens.paddingMD),
                  DropdownButtonFormField<Funcionario>(
                    value: _selected,
                    decoration: EduFormStyles.inputDecoration('Funcionário', icon: Icons.person_outline_rounded),
                    items: staff
                        .map((f) => DropdownMenuItem(value: f, child: Text(f.nomeCompleto)))
                        .toList(),
                    onChanged: (v) => setState(() => _selected = v),
                    validator: (v) => v == null ? 'Seleccione um funcionário' : null,
                  ),
                  const SizedBox(height: AppTokens.paddingMD),
                  TextFormField(
                    controller: _descontos,
                    decoration: EduFormStyles.inputDecoration('Descontos (KZ)', icon: Icons.remove_circle_outline_rounded),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: AppTokens.paddingMD),
                  TextFormField(
                    controller: _bonus,
                    decoration: EduFormStyles.inputDecoration('Bónus (KZ)', icon: Icons.add_circle_outline_rounded),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: AppTokens.paddingMD),
                  TextFormField(
                    controller: _obs,
                    decoration: EduFormStyles.inputDecoration('Observação', icon: Icons.notes_rounded),
                    maxLines: 2,
                  ),
                  const SizedBox(height: AppTokens.paddingLG),
                  EduFormStyles.dialogActions(
                    onCancel: () => Navigator.pop(context),
                    onConfirm: _isSaving ? null : _submit,
                    confirmLabel: 'Registar',
                    isLoading: _isSaving,
                    confirmEnabled: staff.isNotEmpty,
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
