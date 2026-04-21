import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_tokens.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppTokens.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppTokens.slate900,
        primary: AppTokens.slate900,
        secondary: AppTokens.accent,
        surface: AppTokens.surface,
        error: AppTokens.error,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.inter(
          color: AppTokens.slate900,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        headlineMedium: GoogleFonts.inter(
          color: AppTokens.slate900,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: GoogleFonts.inter(
          color: AppTokens.slate700,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppTokens.surface,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppTokens.slate900),
        titleTextStyle: TextStyle(
          color: AppTokens.slate900,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
        ),
      ),
      cardTheme: CardThemeData(
        color: AppTokens.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusMD),
          side: const BorderSide(color: AppTokens.border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppTokens.surface,
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
          borderSide: const BorderSide(color: AppTokens.accent, width: 1.5),
        ),
      ),
    );
  }
}
