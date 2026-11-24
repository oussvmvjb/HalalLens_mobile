import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const primaryGreen = Color(0xFF45BF8A);
  static const darkGreen = Color(0xFF16845B);
  static const lightGreen = Color(0xFFD9F2E5);
  static const background = Color(0xFFF5FBF7);
  static const secondaryBackground = Color(0xFFEAF7EF);
  static const mainText = Color(0xFF183B2D);
  static const secondaryText = Color(0xFF789387);
  static const border = Color(0xFFDCECE2);

  static ThemeData light(String languageCode) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryGreen,
      brightness: Brightness.light,
    ).copyWith(
      primary: darkGreen,
      onPrimary: Colors.white,
      secondary: primaryGreen,
      onSecondary: mainText,
      surface: Colors.white,
      onSurface: mainText,
      error: const Color(0xFFB3261E),
    );

    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      useMaterial3: true,
      fontFamily:
          languageCode == 'en' || languageCode == 'fr' ? 'Roboto' : null,
      fontFamilyFallback:
          languageCode == 'zh'
              ? const ['Microsoft YaHei', 'SimHei', 'Noto Sans CJK SC']
              : null,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: mainText,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 1,
        shadowColor: darkGreen.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: darkGreen, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 52),
          backgroundColor: darkGreen,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkGreen,
          minimumSize: const Size(48, 48),
        ),
      ),
      iconTheme: const IconThemeData(color: darkGreen),
      dividerTheme: const DividerThemeData(color: border, thickness: 1),
    );
  }
}
