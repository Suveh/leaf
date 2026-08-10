import 'package:flutter/material.dart';

/// Centralized color palette for Leaf. Widgets should read colors from
/// [Theme.of(context).colorScheme] / [AppTheme] rather than hardcoding
/// values inline.
class AppColors {
  AppColors._();

  static const Color primaryGreen = Color(0xFF3F7D58);
  static const Color deepGreen = Color(0xFF244A32);
  static const Color leafGreen = Color(0xFF7CB083);
  static const Color earthBrown = Color(0xFF8C6D4F);
  static const Color soilBrown = Color(0xFF4E3B2A);
  static const Color cream = Color(0xFFF6F1E7);
  static const Color error = Color(0xFFB3261E);
}

/// App-wide [ThemeData]. Keep all colors and shared styling here so
/// individual screens never hardcode inline colors/styles.
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primaryGreen,
      brightness: Brightness.light,
      primary: AppColors.primaryGreen,
      onPrimary: Colors.white,
      secondary: AppColors.earthBrown,
      onSecondary: Colors.white,
      surface: AppColors.cream,
      error: AppColors.error,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: AppColors.deepGreen,
        elevation: 0,
        centerTitle: true,
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: AppColors.deepGreen,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: TextStyle(color: AppColors.soilBrown),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: colorScheme.primary),
      ),
    );
  }
}
