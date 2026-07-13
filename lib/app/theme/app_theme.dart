import 'package:flutter/material.dart';

abstract final class AppColors {
  static const primary = Color(0xFF3525CD);
  static const primaryContainer = Color(0xFF4F46E5);
  static const secondary = Color(0xFF006A63);
  static const secondaryContainer = Color(0xFF99EFE5);
  static const surface = Color(0xFFFCF8FF);
  static const surfaceLow = Color(0xFFF5F2FF);
  static const surfaceContainer = Color(0xFFF0ECF9);
  static const outline = Color(0xFFC7C4D8);
  static const text = Color(0xFF1B1B24);
  static const textMuted = Color(0xFF5F5D6D);
  static const error = Color(0xFFBA1A1A);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onErrorContainer = Color(0xFF93000A);
  static const warning = Color(0xFF8A5A00);
  static const warningContainer = Color(0xFFFFE4A8);
  static const primaryFixed = Color(0xFFE2DFFF);
  static const onPrimaryContainer = Color(0xFFDAD7FF);
  static const heroDark = Color(0xFF302F69);
}

abstract final class AppSpacing {
  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const section = 40.0;
  static const page = 48.0;
}

abstract final class AppRadius {
  static const input = 12.0;
  static const control = 14.0;
  static const card = 18.0;
  static const hero = 20.0;
  static const pill = 999.0;
}

abstract final class AppMotion {
  static const quick = Duration(milliseconds: 180);
  static const standard = Duration(milliseconds: 280);
  static const emphasized = Duration(milliseconds: 420);
}

abstract final class AppTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
      error: AppColors.error,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.surface,
      fontFamily: 'Inter',
    );

    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        displaySmall: const TextStyle(
          fontSize: 36,
          height: 1.1,
          fontWeight: FontWeight.w700,
          color: AppColors.text,
        ),
        headlineMedium: const TextStyle(
          fontSize: 28,
          height: 1.25,
          fontWeight: FontWeight.w700,
          color: AppColors.text,
        ),
        headlineSmall: const TextStyle(
          fontSize: 24,
          height: 1.3,
          fontWeight: FontWeight.w600,
          color: AppColors.text,
        ),
        titleLarge: const TextStyle(
          fontSize: 20,
          height: 1.4,
          fontWeight: FontWeight.w600,
          color: AppColors.text,
        ),
        bodyLarge: const TextStyle(
          fontSize: 16,
          height: 1.5,
          color: AppColors.text,
        ),
        bodyMedium: const TextStyle(
          fontSize: 14,
          height: 1.4,
          color: AppColors.textMuted,
        ),
        labelLarge: const TextStyle(
          fontSize: 14,
          height: 1.4,
          fontWeight: FontWeight.w600,
          color: AppColors.text,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.text,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: const BorderSide(color: AppColors.outline),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          backgroundColor: AppColors.primaryContainer,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.control),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          side: const BorderSide(color: AppColors.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.control),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.outline,
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          side: const BorderSide(color: AppColors.outline),
        ),
        selectedColor: AppColors.primaryFixed,
        checkmarkColor: AppColors.primary,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.surfaceContainer,
      ),
    );
  }
}
