import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/edu_form_styles.dart';

class NotificationFormDialog extends ConsumerStatefulWidget {
  const NotificationFormDialog({super.key});

  @override
  ConsumerState<NotificationFormDialog> createState() => _NotificationFormDialogState();
}

class _NotificationFormDialogState extends ConsumerState<NotificationFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titulo = TextEditingController();
  final _mensagem = TextEditingController();
  String _tipo = 'info';
  bool _saving = false;

  @override
  void dispose() {
    _titulo.dispose();
    _mensagem.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await ref.read(notificationServiceProvider).notify(
            titulo: _titulo.text.trim(),
            mensagem: _mensagem.text.trim(),
            tipo: _tipo,
          );
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _saving = false);
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
                  EduFormStyles.dialogHeader(context, 'Novo aviso'),
                  const SizedBox(height: AppTokens.paddingMD),
                  TextFormField(
                    controller: _titulo,
                    decoration: EduFormStyles.inputDecoration('Título', icon: Icons.title_rounded),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Obrigatório' : null,
                  ),
                  const SizedBox(height: AppTokens.paddingMD),
                  TextFormField(
                    controller: _mensagem,
                    maxLines: 3,
                    decoration: EduFormStyles.inputDecoration('Mensagem', icon: Icons.notes_rounded),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Obrigatório' : null,
                  ),
                  const SizedBox(height: AppTokens.paddingMD),
                  DropdownButtonFormField<String>(
                    initialValue: _tipo,
                    decoration: EduFormStyles.inputDecoration('Tipo', icon: Icons.label_outline),
                    items: const [
                      DropdownMenuItem(value: 'info', child: Text('Informação')),
                      DropdownMenuItem(value: 'success', child: Text('Sucesso')),
                      DropdownMenuItem(value: 'warning', child: Text('Aviso')),
                      DropdownMenuItem(value: 'error', child: Text('Urgente')),
                    ],
                    onChanged: (v) => setState(() => _tipo = v!),
                  ),
                  const SizedBox(height: AppTokens.paddingLG),
                  EduFormStyles.dialogActions(
                    onCancel: () => Navigator.pop(context),
                    onConfirm: _saving ? null : _submit,
                    confirmLabel: 'Publicar',
                    isLoading: _saving,
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
