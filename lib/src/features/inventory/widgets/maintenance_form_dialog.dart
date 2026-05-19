import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../domain/entities/ativo_inventario.dart';
import '../../../shared/widgets/edu_form_styles.dart';
import '../inventory_controller.dart';

class MaintenanceFormDialog extends ConsumerStatefulWidget {
  final AtivoInventario ativo;

  const MaintenanceFormDialog({super.key, required this.ativo});

  @override
  ConsumerState<MaintenanceFormDialog> createState() => _MaintenanceFormDialogState();
}

class _MaintenanceFormDialogState extends ConsumerState<MaintenanceFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _desc = TextEditingController();
  final _custo = TextEditingController(text: '0');
  final _por = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _desc.dispose();
    _custo.dispose();
    _por.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      await ref.read(inventoryActionsProvider).registrarManutencao(
            ativoId: widget.ativo.id,
            descricao: _desc.text.trim(),
            custo: double.tryParse(_custo.text.replaceAll(',', '.')) ?? 0,
            realizadoPor: _por.text.trim().isEmpty ? null : _por.text.trim(),
          );
      if (mounted) Navigator.pop(context);
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
                  EduFormStyles.dialogHeader(context, 'Manutenção — ${widget.ativo.nome}'),
                  const SizedBox(height: AppTokens.paddingMD),
                  TextFormField(
                    controller: _desc,
                    decoration: EduFormStyles.inputDecoration('Descrição', icon: Icons.build_outlined),
                    maxLines: 2,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Campo obrigatório' : null,
                  ),
                  const SizedBox(height: AppTokens.paddingMD),
                  TextFormField(
                    controller: _custo,
                    decoration: EduFormStyles.inputDecoration('Custo (KZ)', icon: Icons.payments_outlined),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: AppTokens.paddingMD),
                  TextFormField(
                    controller: _por,
                    decoration: EduFormStyles.inputDecoration('Realizado por', icon: Icons.engineering_outlined),
                  ),
                  const SizedBox(height: AppTokens.paddingLG),
                  EduFormStyles.dialogActions(
                    onCancel: () => Navigator.pop(context),
                    onConfirm: _isSaving ? null : _submit,
                    confirmLabel: 'Registar',
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
