import 'package:flutter/material.dart';
import '../../core/theme/app_tokens.dart';

class EduCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final VoidCallback? onTap;
  final bool elevated;

  const EduCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.onTap,
    this.elevated = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: padding ?? const EdgeInsets.all(AppTokens.paddingMD),
      decoration: BoxDecoration(
        color: color ?? AppTokens.surface,
        borderRadius: BorderRadius.circular(AppTokens.radiusLG),
        border: Border.all(color: AppTokens.border.withValues(alpha: 0.8)),
        boxShadow: elevated ? AppTokens.cardShadow : null,
      ),
      child: child,
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTokens.radiusLG),
        child: content,
      ),
    );
  }
}
