import 'package:flutter/material.dart';

class AppTokens {
  // Paleta Monocromática de Alto Contraste (Branco & Preto)
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFF000000); // Borda preta pura
  
  static const Color slate900 = Color(0xFF000000); // Preto Puro
  static const Color slate700 = Color(0xFF000000); // Preto Puro
  static const Color slate600 = Color(0xFF333333); // Cinza muito escuro para subtextos
  static const Color slate400 = Color(0xFF666666); // Cinza médio
  
  static const Color accent = Color(0xFF000000); // Destaques em preto
  static const Color error = Color(0xFF000000);  // Mantendo o conceito preto e branco (ou vermelho se preferir funcional)
  static const Color success = Color(0xFF000000);

  // Layout Tokens (Bordas mais vivas e definidas)
  static const double radiusMD = 8.0;
  static const double radiusLG = 12.0;
  
  static const double paddingMD = 16.0;
  static const double paddingLG = 24.0;
  static const double paddingXL = 32.0;
}
