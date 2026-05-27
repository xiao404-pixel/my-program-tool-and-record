// lib/theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  // ── Palette ──────────────────────────────────────────────
  static const Color primary = Color(0xFF1A1A2E);
  static const Color secondary = Color(0xFF16213E);
  static const Color accent = Color(0xFF0F3460);
  static const Color highlight = Color(0xFFE94560);
  static const Color surface = Color(0xFF1E2A3A);
  static const Color cardBg = Color(0xFF243447);
  static const Color textPrimary = Color(0xFFF0F4F8);
  static const Color textSecondary = Color(0xFF8DA3B9);
  static const Color divider = Color(0xFF2D3F54);

  // BMI category colours
  static const Color underweight = Color(0xFF4FC3F7);
  static const Color normal = Color(0xFF66BB6A);
  static const Color overweight = Color(0xFFFFCA28);
  static const Color obese1 = Color(0xFFFFA726);
  static const Color obese2 = Color(0xFFEF5350);
  static const Color obese3 = Color(0xFFAB47BC);

  static Color bmiColor(double bmi) {
    if (bmi < 18.5) return underweight;
    if (bmi < 24.0) return normal;
    if (bmi < 27.0) return overweight;
    if (bmi < 30.0) return obese1;
    if (bmi < 35.0) return obese2;
    return obese3;
  }

  // ── ThemeData ─────────────────────────────────────────────
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: primary,
        colorScheme: const ColorScheme.dark(
          primary: highlight,
          secondary: highlight,
          surface: surface,
          onPrimary: textPrimary,
          onSecondary: textPrimary,
          onSurface: textPrimary,
        ),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: primary,
          foregroundColor: textPrimary,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        cardTheme: CardThemeData(
          color: cardBg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: highlight,
            foregroundColor: textPrimary,
            elevation: 0,
            minimumSize: const Size.fromHeight(54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: highlight, width: 2),
          ),
          labelStyle: const TextStyle(color: textSecondary),
          hintStyle: const TextStyle(color: textSecondary),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: secondary,
          selectedItemColor: highlight,
          unselectedItemColor: textSecondary,
          elevation: 0,
        ),
        dividerColor: divider,
        snackBarTheme: SnackBarThemeData(
          backgroundColor: cardBg,
          contentTextStyle: const TextStyle(color: textPrimary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
}
