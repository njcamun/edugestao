import 'package:flutter/material.dart';
import '../../core/theme/app_tokens.dart';

class EduLogo extends StatelessWidget {
  final double height;
  final bool showTagline;
  final Color? titleColor;

  const EduLogo({
    super.key,
    this.height = 72,
    this.showTagline = false,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          AppTokens.logoAsset,
          height: height,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(
            Icons.school_rounded,
            size: height,
            color: AppTokens.primary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          AppTokens.appName,
          style: TextStyle(
            fontSize: height * 0.35,
            fontWeight: FontWeight.w700,
            color: titleColor ?? AppTokens.primaryDark,
            letterSpacing: 0.5,
          ),
        ),
        if (showTagline) ...[
          const SizedBox(height: 4),
          const Text(
            AppTokens.appTagline,
            style: TextStyle(
              fontSize: 12,
              color: AppTokens.textMuted,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }
}
