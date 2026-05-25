import 'package:flutter/material.dart';
import '../../core/theme/app_tokens.dart';

/// Estilos partilhados para diálogos e formulários EDUCLASS.
class EduFormStyles {
  static ShapeBorder dialogShape() => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTokens.radiusLG),
      );

  static BoxConstraints dialogConstraints(BuildContext context, {double maxWidth = 500}) {
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < 640;
    return BoxConstraints(maxWidth: isCompact ? width * 0.96 : maxWidth);
  }

  static EdgeInsets dialogPadding(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 640;
    return EdgeInsets.all(isCompact ? AppTokens.paddingMD : AppTokens.paddingLG);
  }

  static InputDecoration inputDecoration(
    String label, {
    IconData? icon,
    bool enabled = true,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon, size: 20, color: AppTokens.primary) : null,
      filled: true,
      fillColor: enabled ? AppTokens.surface : AppTokens.background,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTokens.radiusMD),
        borderSide: const BorderSide(color: AppTokens.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTokens.radiusMD),
        borderSide: const BorderSide(color: AppTokens.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTokens.radiusMD),
        borderSide: const BorderSide(color: AppTokens.primary, width: 2),
      ),
    );
  }

  static Widget dialogHeader(BuildContext context, String title) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTokens.textPrimary,
                ),
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close_rounded, color: AppTokens.textSecondary),
        ),
      ],
    );
  }

  static Widget dialogActions({
    required VoidCallback onCancel,
    required VoidCallback? onConfirm,
    required String confirmLabel,
    bool isLoading = false,
    bool confirmEnabled = true,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(onPressed: isLoading ? null : onCancel, child: const Text('Cancelar')),
        const SizedBox(width: 8),
        FilledButton(
          onPressed: (isLoading || !confirmEnabled) ? null : onConfirm,
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Text(confirmLabel),
        ),
      ],
    );
  }

  static Widget formSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: AppTokens.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppTokens.radiusSM),
        border: Border.all(color: AppTokens.primary.withValues(alpha: 0.2)),
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTokens.primaryDark),
      ),
    );
  }

  static Widget sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTokens.textSecondary),
      ),
    );
  }

  static Widget imageAction(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTokens.radiusMD),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          border: Border.all(color: AppTokens.border),
          borderRadius: BorderRadius.circular(AppTokens.radiusMD),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppTokens.primary, size: 22),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppTokens.textSecondary)),
          ],
        ),
      ),
    );
  }

  static Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppTokens.textSecondary)),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13, color: AppTokens.textPrimary))),
        ],
      ),
    );
  }

  static Future<bool?> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Confirmar',
    String cancelLabel = 'Cancelar',
    bool destructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: dialogShape(),
        backgroundColor: AppTokens.surface,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, color: AppTokens.textPrimary),
        ),
        content: Text(message, style: const TextStyle(color: AppTokens.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(cancelLabel)),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: destructive
                ? FilledButton.styleFrom(backgroundColor: AppTokens.error)
                : null,
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
  }

  static Widget warningBanner(String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: AppTokens.paddingMD),
      decoration: BoxDecoration(
        color: AppTokens.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTokens.radiusMD),
        border: Border.all(color: AppTokens.warning.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppTokens.warning, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: AppTokens.textPrimary, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
