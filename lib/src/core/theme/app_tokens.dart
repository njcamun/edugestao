import 'package:flutter/material.dart';

/// Tokens de design EDUCLASS — Gestão Escolar.
class AppTokens {
  // Marca
  static const String appName = 'EDUCLASS';
  static const String appTagline = 'Ensinamos com genialidade';
  static const String logoAsset = 'assets/icons/logo.png';

  // Paleta principal
  static const Color primary = Color(0xFF1E88E5);
  static const Color primaryLight = Color(0xFF64B5F6);
  static const Color primaryDark = Color(0xFF0D47A1);

  // Secundárias (uso subtil)
  static const Color accentPurple = Color(0xFF7E57C2);
  static const Color accentYellow = Color(0xFFFFC107);

  // Neutros
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderStrong = Color(0xFFCBD5E1);

  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  // Semânticas
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF57C00);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF0288D1);

  // Compatibilidade com código legado
  static const Color slate900 = textPrimary;
  static const Color slate700 = Color(0xFF334155);
  static const Color slate600 = textSecondary;
  static const Color slate400 = textMuted;
  static const Color accent = primary;

  // Layout
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 20.0;

  static const double paddingSM = 8.0;
  static const double paddingMD = 16.0;
  static const double paddingLG = 24.0;
  static const double paddingXL = 32.0;

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: primaryDark.withValues(alpha: 0.06),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get elevatedShadow => [
        BoxShadow(
          color: primaryDark.withValues(alpha: 0.12),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];
}
